# excel2glossary

## Using the Excel to DITA glossary script

## Usage
```
excel2ditaglossary <Excel file> <output directory>
```
## Summary
excel2ditaglossary allows you to use an Excel spreadsheet to maintain glossary entries, then use that spreadsheet to create a DITA glossary topic for each entry.

## Excel Format
The first row is considered the header row and will never be processed. The spreadsheet structure looks like this:

<table>
<tr>
	<th>Term</th>
	<th>Definition</th>
	<th>Acronym</th>
</tr>
<tr>
	<td>actual term</td>
	<td>actual definition</td>
	<td>actual acryonym</td>
</tr>
</table>

The third column, the acronym, is optional. If used, the glossary for that term will use the expanded form for the DITA glossary. There is no requirement for an acronym, and you can have a mix of terms with and without acronyms. 

An Excel template is included in the build.

### Sample

<table>
<tr>
	<th>Term</th>
	<th>Definition</th>
	<th>Acronym</th>
</tr>
<tr>
	<td>AXI Coherency Extensions</td>
	<td>The AXI Coherency Extensions (ACE) provide additional channels and signaling to an AXI interface to support system level cache coherency.</td>
	<td>ACE</td>
</tr>
<tr>
<td>ACE protocol</td>
<td>The AXI Coherency Extensions protocol, that adds signals to an AMBA AXI4 interface, to support managing the coherency of a distributed memory system.</td>
<td></td>
</table>


## Output Directory

This step is optional. If you do not provide a directory, the script uses the directory that the Excel file is in to generate the topics. You do not have create the directory before specifying it. It will be created for you, if it doesn't exist.

## Requirements

* Ruby 2.x
* Ruby gems: 
  * Nokogiri
  * creek

### Getting started with Ruby

If you haven't ever used ruby, you may need to install it. 

- [ruby language](https://www.ruby-lang.org/en/downloads/)

There are versions for linux, Mac OS X, and Windows.
Ruby gems are libraries used to perform certain things. I used two for this project; creek is used to read the Excel data, nokogiri is the XML library used to read and write XML data. 

After Ruby is installed, you need to install the libraries. This is done by running: 
```
bundler install
```
This will look at your Ruby gems and install any needed gems for this script. 

## Change History
2019-05-06: 	

* Public release
* Added Acronym column to Excel template. 
* Added expanded form to the glossary entry.