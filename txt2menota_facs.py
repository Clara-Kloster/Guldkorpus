# The following code takes .txt files written on every second line and processes them into Menota-style XML (Facs level only)
import sys
import re
import string
write_file = open(sys.argv[1] + '.xml', 'w')

# WRITE HEADER
write_file.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<?oxygen RNGSchema=\"http://www.menota.org/menotaP5.rng\" type=\"xml\" ?>\n<!DOCTYPE TEI\n[\n<!ENTITY % Menota_entities SYSTEM\n'http://www.menota.org/menota-entities.txt' >\n%Menota_entities;\n<!ENTITY % Extra-entities SYSTEM\n'ExtraEntities.txt' >\n%Extra-entities;]>\n<TEI xmlns=\"http://www.tei-c.org/ns/1.0\" xmlns:me=\"http://www.menota.org/ns/1.0\">\n<teiHeader/>\n<text>\n<body>\n")

line_break = 1
header = 0
delete = 0
next_page = ''
pagebreak = ''

# MAIN RUN-THROUGH OF LINES
with open(sys.argv[1] + '.txt', 'r') as read_file:
    for line in read_file:
        line_break = line_break + 1
        # Only read odd-numbered lines
        if line_break % 2 == 0:
            # Find all <note> tags or [NOTE: ], xml tags and replace spaces with underscores
            for note in re.findall(r'<note>([^<]*)</note>', line):
                line = re.sub(r"(.*)%s(.*)" % re.escape(note), r"\1%s\2" % note.replace(' ', '_'), line)
            for shorthandNote in re.findall(r'\[NOTE:([^\]]*)\]', line):
                line = re.sub(r'(.*)\[%s\](.*)' % re.escape(shorthandNote), r'\1<note>%s</note>\2' % shorthandNote.replace(' ', '_'), line)
            for xmlTag in re.findall(r'<([^>]*)>', line):
                line = re.sub(r'(.*)<%s>(.*)' % re.escape(xmlTag), r'\1<%s>\2' % xmlTag.replace(' ', '_'), line)

            # Process lines
            line_number = line_break / 2
            facs = line.split()
            write_file.write("<lb n=\"%s\"/>\n" % line_number)
            i = 0
            while i < len(facs):
                write_file.write("<w>%s</w>" % facs[i].replace('_', ' '))

                i = i + 1
write_file.write("</body>\n</text>\n</TEI>")
