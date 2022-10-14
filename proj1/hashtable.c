#include "hashtable.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
/*
 * This creates a new hash table of the specified size and with
 * the given hash function and comparison function.
 */
HashTable *createHashTable(int size, unsigned int (*hashFunction)(void *),
                           int (*equalFunction)(void *, void *)) {
    int i = 0;
    
    HashTable *newTable = malloc(sizeof(HashTable));
    newTable->size = size;
    newTable->data = malloc(sizeof(struct HashBucket *) * size);
    
    for (i = 0; i < size; ++i) {
      newTable->data[i] = NULL;
    }

    newTable->hashFunction = hashFunction;
    newTable->equalFunction = equalFunction;
    
    return newTable;
}

/*
 * This inserts a key/data pair into a hash table.  To use this
 * to store strings, simply cast the char * to a void * (e.g., to store
 * the string referred to by the declaration char *string, you would
 * call insertData(someHashTable, (void *) string, (void *) string).
 * Because we only need a set data structure for this spell checker,
 * we can use the string as both the key and data.
 * --------------------------------------------------------------------
 * Mind this: we can use the string as both the key and data.
 * Therefore, when we get a word from the dictionary, this also represent the key information.
 */
void insertData(HashTable *table, void *key, void *data) {
    // HINT:
    
    // 1. Find the right hash bucket location with table->hashFunction.   
    unsigned int pos = table->hashFunction(key);
    
    // 2. Allocate a new hash bucket struct.
    struct HashBucket *temp = (struct HashBucket *) malloc (sizeof(struct HashBucket));
    
    temp->key = (char *) malloc (strlen(key) + 1);
    strcpy(temp->key, (char *) key);
    temp->data = (char *) malloc (strlen(data) + 1);
    strcpy(temp->data, (char *) data);
    temp->next = NULL;

    // 3. Append to the linked list or create it if it does not yet exist. 
    // the hashfunction should be taken into consideration. the hash function should take size into consideration.
    if (table->data[pos] == NULL) {
      table->data[pos] = temp;
    } else {
      struct HashBucket *cursor = table->data[pos];
    	while (cursor->next != NULL) cursor = cursor->next;
      cursor->next = temp;
    }
    
}

/*
 * This returns the corresponding data for a given key.
 * It returns NULL if the key is not found. 
 */
void *findData(HashTable *table, void *key) {
    // HINT:
    // 1. Find the right hash bucket with table->hashFunction.
    unsigned int pos = table->hashFunction(key);

    // 2. Walk the linked list and check for equality with table->equalFunction.
    struct HashBucket *cursor = table->data[pos];
    if (cursor == NULL) return NULL;
    else {
      while (cursor != NULL) {
        if (table->equalFunction(key, cursor->key) == 0) {
    			return cursor->data;
    		}
        cursor = cursor->next;
  	  }
  	  return NULL;
    }  
}
