#!/usr/bin/env ruby

require 'tempfile'
require 'fileutils'
require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'yaml'

VERSION = "0.3.0"

class MDUtils


    def self.summarize(args)

        filename = args[0]
        options  = args[1]

        if !File.exist?(filename)
            abort("Please enter a valid MD file.")
        end

        puts "Generating summary for file " + filename

        # In order to be sure to not write on existing file
        temp_file = Tempfile.new("summarizeMd")

        summary = generate_sumary_heading(options)
        forbidden_words = ['Table of contents', 'define', 'pragma', '#!', '# Desc:']

        File.open(filename, 'r') do |f|
            if options.verbose 
                puts "Generate summary for section(s): "
            end
            f.each_line do |line|
                if !(!line.start_with?("#") || forbidden_words.any? { |w| line =~ /#{w}/ }) 
                    title = line.gsub("#", "").strip
                    # Create meaningful anchor links
                    href = line.delete('#:~/.()')    # Remove special characters
                    href = href.lstrip               # Remove leading whitespaces
                    href = href.gsub(" ", "-").strip # Replace whitespaces with minus
                    href = "#{href}"                 # Add hashmark as leading character
                    anchor = "<div id='#{href}'/>\n\n"
                    temp_file.puts anchor + line
                    summary += "  " * (line.count("#")-1) + "- [#{title}](\##{href})" + "\n"
                    if options.verbose 
                        puts "\t- [#{title}]"
                    end
                 else
                     temp_file.puts line
                 end   
               end
                        temp_file.close
        end
                summary += "  \n\n"
        
                with_output_file(options, filename) do |output_file|
                    if (options.replace_summary_token.empty?)
                        prepend_to_file(summary, temp_file, output_file) 
                    else
                        replace_token_with(options.replace_summary_token, summary, temp_file, output_file)
                    end
                end
                
                temp_file.unlink
                puts "Done.\n"
    end #(end summarize)
        
        def self.prepend_to_file(toPrepend, source_file, target_file)
            File.open(target_file, 'w') do |fo|
                fo.puts(toPrepend)
                File.foreach(source_file) do |li|
                    fo.puts li
                end
            end
        end
        
        def self.replace_token_with(token, toPrepend, source_file, target_file)
            File.open(target_file, 'w') do |fo|
                File.foreach(source_file) do |li|
                    if li.include?(token)
                        fo.puts toPrepend
                    else
                        fo.puts li
                    end
                end
            end
        end
        
        def self.with_output_file(options, filename)
            outputFilename = "summarized_" + filename
            if !options.output.empty? 
                outputFilename = options.output
                outputComponents = outputFilename.split(".")
                if outputComponents.last.downcase != "md" 
                    outputFilename += ".md"
                    if options.verbose 
                        puts "Forcing adding extension."
                    end
                end
            end
            
            if File.file?(outputFilename) && !options.force
                puts "output file exists. Use --force or -f to overwrite it."
                exit 1
            elsif File.directory?(outputFilename)
                puts "output file cannot be a directory"
                exit 2
            else
               File.open(outputFilename, "w") do |output_file|
                  yield output_file 
               end
            end
        end
        
        def self.generate_sumary_heading(options)
            if options.heading_level == 0
                return String.new
            else
                heading = String.new
                options.heading_level.times { heading << "\#" }
                heading << " Summary \n\n"
                return heading
            end
        end

end

class OptparseSummarize

  CODES = %w[iso-2022-jp shift_jis euc-jp utf8 binary]
  CODE_ALIASES = { "jis" => "iso-2022-jp", "sjis" => "shift_jis" }

  #
  # Return a structure describing the options.
  #
  def self.parse(args)
    # The options specified on the command line will be collected in *options*.
    # We set default values here.
    options = OpenStruct.new
    options.encoding = "utf8"
    options.verbose = false
    options.force = false
    options.output = String.new
    options.replace_summary_token = String.new
    options.heading_level = 1

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: summarizeMD <filename> [options]"

      opts.separator ""
      opts.separator "Specific options:"

      # Output name.
      opts.on("-o", "--output [filename]",
              "Specify output filename") do |out|
        options.output << out
      end
      
      opts.on("-t", "--replace_summary_token [summary_token]",
              "Replace the line containing the supplied token, with the summary, instead of putting the summary in the top of the file. If the token is not found, then no summary is inserted.") do |out|
        options.replace_summary_token << out
      end
      
      opts.on("-l", "--heading_level [heading level]", Integer,
              "Specify the heading level, eg. The number of ## to insert before the Summary heading. Set this to 0 to not add a heading to the summary.") do |l|
        options.heading_level = l
      end

      # Boolean switch.
      opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        options.verbose = v
      end
      
      # Boolean switch.
      opts.on("-f", "--[no-]force", "force writing the output file, even if its overwrite an existing file") do |f|
        options.force = f
      end

      opts.separator ""
      opts.separator "Common options:"

      # No argument, shows at tail.  This will print an options summary.
      # Try it and see!
      opts.on("-h", "--help", "Show this message") do
        puts opts
        exit
      end

      # Another typical switch to print the version.
      opts.on("--version", "Show version") do
        puts "#{VERSION}"
        exit
      end
      
      opts.separator ""
      opts.separator "Exit codes:"
      opts.separator "    1 = output file exists, and called without --force (-f)"
      opts.separator "    2 = output file cannot be a directory"
      opts.separator "    3 = --heading_level (-l) must be a positive integer or zero"
    end

    opt_parser.parse!(args) 
  
    options
  end  # parse()

end  # class OptparseExample

## ---- Main ----


options = OptparseSummarize.parse(ARGV)
if options.heading_level < 0
    puts "--heading_level (-l) must be a positive integer or zero"
    exit 3
end

mdUtils = MDUtils.summarize([ARGV[0], options]);
