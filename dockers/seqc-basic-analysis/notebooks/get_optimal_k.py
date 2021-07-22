import numpy as np
from sklearn import metrics
import pandas as pd
import phenograph
import scanpy
from matplotlib import pyplot as plt
from matplotlib.patches import Rectangle
import seaborn
import sys, os, io

# Class to suppress output from PhenoGraph
class HiddenPrints:
    def __enter__(self):
        self._original_stdout = sys.stdout
        sys.stdout = open(os.devnull, "w")

    def __exit__(self, exc_type, exc_val, exc_tb):
        sys.stdout.close()
        sys.stdout = self._original_stdout


# Helper class to search for the optimal k parameter in PhenoGraph clustering
# KOptimizer does not store any instance variables
class KOptimizer:

    # Retrieve cluster assignments
    @staticmethod
    def get_clusters(k, data, k_lookup):
        if k in k_lookup:
            clusters = k_lookup[k]
        else:
            # TODO: need clean way to pass all args to Phenograph
            with HiddenPrints():
                clusters, _, _ = phenograph.cluster(data, k=k)
            k_lookup[k] = clusters
        return clusters

    @staticmethod
    def get_Rand_Index(k1, k2, data, k_lookup):
        # Retrieve PhenoGraph clusters for k=k1 if exist
        k1_clusters = KOptimizer.get_clusters(k1, data, k_lookup)
        k2_clusters = KOptimizer.get_clusters(k2, data, k_lookup)
        return metrics.adjusted_rand_score(k1_clusters, k2_clusters)

    @staticmethod
    def plot_Rand_Indices(data, min_k, max_k, interval, window, k_lookup, opt_k=-1):

        ks = np.arange(min_k, max_k + 1, interval)  # k values of interest
        Rand_indices = pd.DataFrame(np.zeros((len(ks), len(ks))), index=ks, columns=ks)
        Rand_indices.index.name = "k1"
        Rand_indices.columns.name = "k2"

        for i, k1 in enumerate(ks):
            for j, k2 in enumerate(ks):
                Rand_indices.iloc[i, j] = KOptimizer.get_Rand_Index(
                    k1, k2, data, k_lookup
                )

        # Plot heatmap of Rand Indices
        plt.figure(figsize=(8, 8))
        ax = seaborn.heatmap(
            Rand_indices, cmap=("coolwarm"), square=True, vmin=0, vmax=1
        )
        ax.invert_yaxis()
        seaborn.set(font_scale=1)
        if opt_k >= 0:
            opt_k_index = np.argwhere(ks == opt_k)
            ax.add_patch(
                Rectangle(
                    (opt_k_index, opt_k_index),
                    1,
                    1,
                    fill=False,
                    edgecolor="white",
                    lw=3,
                )
            )
            ax.add_patch(
                Rectangle(
                    (opt_k_index - window, opt_k_index - window),
                    2 * window + 1,
                    2 * window + 1,
                    fill=False,
                    edgecolor="white",
                    lw=1,
                )
            )
        plt.xlabel("k1")
        plt.ylabel("k2")
        plt.title("Adjusted Rand Score")
        plt.show()
        plt.close()

    # Find smallest k with satisfactory cost given constraints
    def find_k(
        self,
        data: scanpy.AnnData,
        k0: int,
        interval: int = 5,
        threshold: float = 0.90,
        window: int = 2,
        verbose: bool = True,
        display: bool = False,
    ) -> int:
        # TODO: Set stopping condition; assumes process will terminate on own
        k_lookup = dict()  # lookup table, k: PhenoGraph clusters kor k
        k_low_bound = 5  # minimum k value that will be considered
        k_window = interval * window
        min_k = np.inf  # minimum k value that was tested
        max_k = -1  # maximum k value that was tested
        k1 = k0 - interval  # first k value to test
        c = 0.0  # cost associated with current k

        # Increase k to find satisfactory c
        while c <= threshold:
            k1 += interval
            c = 1.0
            min_k2 = k1 - k_window
            max_k2 = k1 + k_window
            # Note: RI does not always increase as k2 -> k1
            k2_vals = np.arange(min_k2, max_k2 + 1, interval)
            condition = (k2_vals >= k_low_bound) & (k2_vals != k1)  # RI(k1, k1) = 1.0
            k2_vals = np.extract(condition, k2_vals)
            min_k = min(min_k, k2_vals.min())
            max_k = max(min_k, k2_vals.max())
            # Get Rand Index for each pair of k's
            if verbose:
                print(f"Calculating for k: {k1}", end="")
            for k2 in k2_vals:
                c = min(KOptimizer.get_Rand_Index(k1, k2, data, k_lookup), c)
                print(".", end="")
            print(f" Min. Rand Index is: {c}")

        # Readout
        if verbose:
            print(f"Discovered optimal k: {k1}")
            print(f"Min. Rand Index for {k1}: {c}")
        if display:
            KOptimizer.plot_Rand_Indices(
                data, min_k, max_k, interval, window, k_lookup, opt_k=k1
            )

        return k1
