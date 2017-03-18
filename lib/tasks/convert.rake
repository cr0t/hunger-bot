namespace :convert do
  desc 'Converts SRT file to simple TXT (by grepping only phrases)'
  task :srt, [:input_file] do |_task, args|
    basename = File.basename(args[:input_file], '.*')

    file = SRT::File.parse(File.new(args[:input_file]))
    text_only = file.lines.map do |line|
      line.text.join(' ')
    end

    File.open("#{basename}.txt", 'w') do |output_file|
      text_only.each do |line|
        output_file.puts(line)
      end
    end

    puts "Total #{text_only.count} lines of dialogues."
  end
end
