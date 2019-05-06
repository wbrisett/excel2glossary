require 'bundler/setup'
require 'creek'
require 'nokogiri'


def writeFile (file)
  # Need path for map
  filename = File.join("#{@output}/glossentries/",@filename)
  File.open("#{filename}", "w") { |f| f.write file }
  puts "Wrote: #{filename}"
end

@topics = Array.new
@keys = Array.new


xlsheet = ARGV[0]
@output = ARGV[1]

Dir::mkdir(@output) unless File.exists?(@output)
Dir::mkdir("#{@output}/glossentries/") unless File.exists?("#{@output}/glossentries/")

doc = Creek::Book.new(xlsheet)
sheet = doc.sheets[0]

sheet.rows.each.with_index do |row, idx|
  # index 0 is the header row. If you remove the header row, then remove the if statement.

  if idx != 0
    @filename = "#{row["A#{idx+1}"].downcase.delete(' ').gsub(/[(,\-)\/']/ , '_')}.dita"
    @topics.push(@filename)
    @keys.push("#{row["A#{idx+1}"].downcase.delete(' ').gsub(/[(,)\-\/']/ , '_')}")
    begin
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.doc.create_internal_subset(
              'glossentry',
              "-//OASIS//DTD DITA Glossary//EN",
              "glossary.dtd"
          )
          xml.glossentry('id' => row["A#{idx+1}"].downcase.delete(' ').gsub(/[(,)\-\/']/ , '_')) do
            xml.glossterm row["A#{idx+1}"]
            xml.glossdef row["B#{idx+1}"]
            if row["C#{idx+1}"] # write out longer form of glossary entry if acroynm exists
              xml.glossBody do
                xml.glossSurfaceForm row["A#{idx+1}"] + " (" + row["C#{idx+1}"] + ")" # put columns a and c together
                xml.glossAlt do
                  xml.glossAcronym row["C#{idx+1}"] # column c only in acronym
                end
              end
            end
          end
        end
        writeFile(builder.to_xml)
    end
  end
end


### build the DITA Map

builder = Nokogiri::XML::Builder.new do |ditamap|
  ditamap.doc.create_internal_subset(
    'map',
    "-//OASIS//DTD DITA Map//EN",
    "map.dtd"
  )
  ditamap.map('id' =>'glossary_entries')do
    ditamap.title 'Glossary Map'
    @topics.each.with_index do |indfile, idx|
      ditamap.topicref('href' => "glossentries/#{indfile}", 'keys' => @keys[idx], 'toc' => 'no')
    end
  end
end

# build map file
contents = builder.to_xml
filename = File.join(@output,'glossaryentries.ditamap')
File.open("#{filename}", "w") { |f| f.write contents }
puts "Wrote: #{filename}"