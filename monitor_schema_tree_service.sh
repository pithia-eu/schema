#!/bin/bash

file_removed() {
    TIMESTAMP=`date`
    echo "[$TIMESTAMP]: The file $1$2 was removed" >> schema_log
}

file_modified() {
    TIMESTAMP=`date`
    echo "[$TIMESTAMP]: The file $1$2 was modified" >> schema_log
}

file_created() {
    TIMESTAMP=`date`
    echo "[$TIMESTAMP]: The file $1$2 was created" >> schema_log
}


update_file() {
    if [ -f "/var/www/pithia.eu/html/schemas/2.2/$2" ]; then
    rm /var/www/pithia.eu/html/schemas/2.2/$2
    fi
    cp $1$2 /var/www/pithia.eu/html/schemas/2.2/$2
    TIMESTAMP=`date`
    echo "[$TIMESTAMP]: File updated: /var/www/pithia.eu/html/schemas/2.2/$2" >> schema_log
}

delete_file() {
    rm /var/www/pithia.eu/html/schemas/2.2/$1
    TIMESTAMP=`date`
    echo "[$TIMESTAMP]: File deleted: /var/www/pithia.eu/html/schemas/2.2/$1" >> schema_log
}


inotifywait -q -m -r -e modify,delete,create /home/metadata/schema/2.2 | while read DIRECTORY EVENT FILE; do
    case $EVENT in
        MODIFY*)
            file_modified "$DIRECTORY" "$FILE"
	    update_file "$DIRECTORY" "$FILE"
            ;;
        CREATE*)
            file_created "$DIRECTORY" "$FILE"
            ;;
        DELETE*)
            file_removed "$DIRECTORY" "$FILE"
	    delete_file "$FILE"
            ;;
    esac
done
