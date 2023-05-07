# TonUINO-Tools

## Musik für den TonUINO verwalten
Die Tonuino-Tools sind eine Sammlung an Bash-Scripten, um SD-Karten für einen TonUINO zu verwalten. Diese Scripte können sowohl auf MacOs als auch auf Linux-Systemen ausgeführt werden. Das Ziel ist es, das Bespielen von TonUINO-Boxen so einfach wie möglich zu halten.
Der Prozess zum Bespielen der Boxen kann in drei Schritte aufgeteilt werden, entsprechend finden sich hier drei unterschiedliche Scripte.

## Schritt 1: Musik erfassen und auswählen
Das Script `scan_library.sh` durchsucht die eigene Musikbibliothek auf der Festplatte und baut daraus eine tabellarische Übersicht als CSV-Datei. In dieser Datei können anschließend die gewünschten Alben ausgewählt werden und an [Schritt 2](#schritt-2-musik-auf-sd-karte-kopieren) übergeben werden.

**Vorbedingungen**: Es existiert ein Ordner auf der Festplatte, dessen Unterordner die Interpreten sind, welche wiederum jeweils die zugehörigen Alben mit den MP3s enthalten. Ein möglicher Pfad wäre also `Musik/Tchaikovsky/Violin Concerto In D Major`. 
Um das Script aus dem Internet ausführbar zu machen, muss zunächst in einem Terminal `chmod +x scan_library.sh` ausgeführt werden.

**Ausführung**: Das Script kann einfach in einem Terminal ausgeführt werden. Bei der Ausführung muss mindestens der Pfad zur Musikbibliothek mitgegeben werden. Optional kann zusätzlich der Name der zu erstellenden CSV-Datei mitgegeben werden (Standardwert ist *my_library.csv* im selben Verzeichnis).
```
$ ./scan_library.sh /Users/Me/Documents/TonUINO_Music/ output.csv

Album paths have been written to output.csv.  
```

**CSV-Output**  

|artist|album|path|card_number|mode|
|---|---|---|---|---|
|Tchaikovsky|Piano Concerto No. 1 in B-flat minor|/Users/Me/Documents/TonUINO_Music/Tchaikovsky/Piano Concerto No. 1 in B-flat minor|||
|Tchaikovsky|Violin Concerto In D Major|/Users/Me/Documents/TonUINO_Music/Tchaikovsky/Violin Concerto In D Major|||
|Misc|Summer-Mix|/Users/Me/Documents/TonUINO_Music/Misc/Summer-Mix|||

Die entstehende CSV-Datei kann mit den meisten Tabellenverarbeitungstools bearbeitet werden. Unter MacOS ist standardmäßig bereits Numbers installiert. Beim Speichern sollte darauf geachtet werden, dass auch wieder im CSV-Format gespeichert wird (Datei -> Export nach -> CSV).

Nun können in der Spalte *card_number* die Zahlen für die zu erstellenden RFID-Karten eingetragen werden (1-99). Es ist nicht notwendig bei 1 zu beginnen (falls beispielsweise ergänzende RFID-Karten für eine existierende SD-Karte erstellt werden sollen). Bei Alben, die nicht kopiert werden sollen, darf entsprechend keine *card_number* eingetragen werden.

In der Spalte *mode* kann der Wiedergabemodus gewählt werden. Hierbei sind folgende Werte möglich:
* 1: Hörspielmodus (Abspielen einer zufälligen Datei aus dem Ordner, die Vor- und Rücktaste sind gesperrt)
* 2: Albummodus (Wiedergabe des  kompletten Ordners)
* 3: Partymodus (Wiedergabe des Ordners in zufälliger Reihenfolge)
* 5: Hörbuchmodus (Wiedergabe des Ordners mit Speichern des Fortschritts) 		

Nachdem die CSV-Datei hinsichtlich *card_number* und *mode* befüllt wurde, kann der zweite Schritt gestartet werden.

## Schritt 2: Musik auf SD-Karte kopieren
Das Script `copy_library.sh` kopiert die ausgewählten Alben auf eine SD-Karte und benennt dabei die Ordner und Dateien im TonUINO-Format um. Anschließend erstellt das Script eine CSV-Datei zur Vorbereitung des [Schritt 3](#schritt-3-erstellen-der-rfid-karten) zum Erstellen der RFID-Karten.

**Vorbedingungen**: Schritt 1 wurde ausgeführt, um die beschriebene CSV-Datei zu erstellen. 
Um das Script aus dem Internet ausführbar zu machen, muss zunächst in einem Terminal `chmod +x copy_library.sh` ausgeführt werden.

**Ausführung**: Das Script kann einfach in einem Terminal ausgeführt werden. Bei der Ausführung müssen mindestens der Name der einzulesenden CSV-Datei sowie der Ausgabepfad für die Ordner und MP3-Dateien angegeben werden. Optional kann als dritter Parameter der Name der zu erstellenden weiteren CSV-Datei angegeben werden (Standardwert ist *my_cards.csv*).

```
$ ./copy_library.sh my_library.csv /Volumes/SD-Card/ my_cards.csv

Album files have been copied successfully. You can find the card file at my_cards.csv
```

Die erstellte CSV-Datei gibt einen Überblick über die kopierten Alben und bereitet das Beschreiben der RFID-Karten vor. 
Wenn bei einer Karte kein Modus hinterlegt wurde (*mode* leer), wird automatisch der Albummodus angenommen (*mode* 2).

|artist|album|mode|folder_number|number_of_files|rfid_content|
|---|---|---|---|---|---|
|Tchaikovsky|Piano Concerto No. 1 in B-flat minor|2|1|4|13 37 B3 47 02 01 02 00 00 00 00 00 00 00 00 00|
|Tchaikovsky|Violin Concerto In D Major|2|2|8|13 37 B3 47 02 02 02 00 00 00 00 00 00 00 00 00|
|Misc|Summer-Mix|3|3|45|13 37 B3 47 02 03 03 00 00 00 00 00 00 00 00 00|

## Schritt 3: Erstellen der RFID-Karten
Der Schritt 3 ist aktuell noch nicht automatisiert. Hierfür arbeite ich noch an einem Script, welches ich anschließend ergänze.

## Weiterführende Informationen
Die Tonuino-Tools Scripte sind entstanden, da ich einen einfachen und direkten Weg gesucht habe unter MacOs meine TonUINO SD-Karten zu beschreiben. Die TonUINO Community hat viele weitere Tools erstellt, die abhängig vom Use-Case passender sein könnten. Vor der Nutzung der zuvor beschriebenen Scripte lohnt sich daher ein Blick in die [TonUINO Community](https://discourse.voss.earth/t/uebersicht-der-tools-anleitungen-fuer-den-tonuino/5972).

Zur Fehlerbehebung und Weiterentwicklung der TonUINO-Tools freue ich mich über Pull-Requests oder E-Mails an hallo (at) fredericsblog.de.