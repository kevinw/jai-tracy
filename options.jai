// This file is for handling command-line options passed
// by the metaprogram.

// There are two hooks that we supply to do this. One
// handles individual options, and one logs a help string.


init :: (p: *Metaprogram_Plugin, options: [] string) -> bool {
    my := cast(*My_Plugin) p;
    for options if it == {
      case "-min_size";
        if it_index >= options.count-1 {
            log_error("Command line: Missing argument to -min_size.\n");
            return false;
        }

        arg := options[it_index+1];
        result, success, remainder := string_to_int(arg);
        if !success {
            log_error("[Iprof] Command line: Argument to -min_size was expected to be an integer, but we got '%'.\n", arg);
            return false;
        }

        if eat_spaces(remainder) {
            log_error("[Iprof] Command line: Found junk at the end of the argument to -min_size '%'.\n", remainder);
            return false;
        }

        my.min_size = result;
        it_index += 1;

      case "-modules";
        my.instrument_modules = true;
    }

    return true;
}

log_help :: (p: *Metaprogram_Plugin) {
    log(HELP_STRING, MINIMUM_SIZE_DEFAULT);
}

HELP_STRING :: #string DONE
-csv filename      Output batch profiling data as a .csv-formatted file called 'filename'.
                   (csv files can be loaded by pretty much any spreadsheet program).
                   For now this is slightly awkward, because you specify this option
                   at compile-time, but the file is written at runtime (and overwritten
                   each time you run your instrumented program!)

-min_size n        Instrument only procedures that are at least 'n' expressions large.
                   Use this to skip instrumenting small procedures, reducing overhead,
                   while still instrumenting major program locations.
                   The default is %1.

-modules           Instrument modules, as well as the main program.
DONE
