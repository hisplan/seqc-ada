version 1.0

import "modules/Greeter.wdl" as Greeter

workflow SEQC {

    input {
        String name = name
    }

    call Greeter.Say {
        input:
            name = name
    }

    call Greeter.SayToFile {
        input:
            message = Say.out
    }

    output {
        String outString = Say.out
        File outFile = SayToFile.out
    }
}
