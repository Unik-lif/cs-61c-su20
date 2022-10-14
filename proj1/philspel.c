/*
 * Include the provided hash table library.
 */
#include "hashtable.h"

/*
 * Include the header file.
 */
#include "philspel.h"

/*
 * Standard IO and file routines.
 */
#include <stdio.h>

/*
 * General utility routines (including malloc()).
 */
#include <stdlib.h>

/*
 * Character utility routines.
 */
#include <ctype.h>

/*
 * String utility routines.
 */
#include <string.h>

/*
 * This hash table stores the dictionary.
 */
HashTable *dictionary;

int buffer = -1;

/*
 * The MAIN routine.  You can safely print debugging information
 * to standard error (stderr) as shown and it will be ignored in 
 * the grading process.
 */
int main(int argc, char **argv) {
  if (argc != 2) {
    fprintf(stderr, "Specify a dictionary\n");
    return 0;
  }
  /*
   * Allocate a hash table to store the dictionary.
   */
  fprintf(stderr, "Creating hashtable\n");
  dictionary = createHashTable(2255, &stringHash, &stringEquals);

  fprintf(stderr, "Loading dictionary %s\n", argv[1]);
  readDictionary(argv[1]);

  fprintf(stderr, "Dictionary loaded\n");
  
  /*
  for (int i = 0; i < dictionary->size; i++) {
    if (dictionary->data[i] != NULL) {
      
      cursor = dictionary->data[i];
      
      printf("%d:\n", i);
      
      while (cursor != NULL) {
        printf("word = %s\n", (char *) cursor->data);
        cursor = cursor->next;
      }
      
    }
  }
  */
  // dictionary test is passed, next step is the processInput part.
  
  fprintf(stderr, "Processing stdin\n");
  processInput();

  /*
   * The MAIN function in C should always return 0 as a way of telling
   * whatever program invoked this that everything went OK.
   */
  return 0;
}

/*
 * This should hash a string to a bucket index.  Void *s can be safely cast
 * to a char * (null terminated string) and is already done for you here 
 * for convenience.
 */
unsigned int stringHash(void *s) {
  char *string = (char *)s;
  // -- TODO --
  unsigned int hash = 5381;
  int c = 0;

  while (c = *string++) hash = ((hash << 5) + hash) + c; /* hash * 33 + c */

  return hash % (dictionary->size);  
}

/*
 * This should return a nonzero value if the two strings are identical 
 * (case sensitive comparison) and 0 otherwise.
 */
int stringEquals(void *s1, void *s2) {
  char *string1 = (char *)s1;
  char *string2 = (char *)s2;
  // -- TODO --
  while (*string1++ == *string2++) {
  	if (*string1 == '\0') return 0;
  }
  return *string1 - *string2;
}

/*
 * This function should read in every word from the dictionary and
 * store it in the hash table.  You should first open the file specified,
 * then read the words one at a time and insert them into the dictionary.
 * Once the file is read in completely, return.  You will need to allocate
 * (using malloc()) space for each word.  As described in the spec, you
 * can initially assume that no word is longer than 60 characters.  However,
 * for the final 20% of your grade, you cannot assumed that words have a bounded
 * length.  You CANNOT assume that the specified file exists.  If the file does
 * NOT exist, you should print some message to standard error and call exit(1)
 * to cleanly exit the program.
 *
 * Since the format is one word at a time, with new lines in between,
 * you can safely use fscanf() to read in the strings until you want to handle
 * arbitrarily long dictionary chacaters.
 */
void readDictionary(char *dictName) {
  // -- TODO --
  int c = 0;
  int wordLength = 0;         /* use wordLength to store the length of the word. */
 
  int overFlag = 0;           /* use overFlag to judge whether the length is over 60. */
  int stopFlag = 0;           /* use stopFlag to judge whether the word has ended. */
  int bufferLength = 0;       /* use bufferLength to store the length after resizing. */

  char *temp = NULL;
  char tempSmall[61] = {0};

  const int step = 10;        /* resizing step. */
  

  FILE *fp = fopen(dictName, "r");
  
  /* fail to open the dictionary.txt. */
  if (fp == NULL) {
  	perror("Error");
  	exit(1);
  }
  while ((c = fgetc(fp)) != EOF) {
    if (isalpha(c)) {
      stopFlag = 1;
		
		  /** if the word is short, simply using char[61] to store it */
		  if (wordLength <= 60) {
			  tempSmall[wordLength++] = c;
      } else if (overFlag == 0) {
			
         overFlag = 1;   /** First time to be longer than 60 characters, set overFlag perparing for malloc */
			   wordLength++;
			   temp = (char *) malloc (sizeof(char) * (wordLength + step + 1));
			
			   bufferLength = wordLength + step;

			   for (int i = 0; i < wordLength - 1; i++) {
				    temp[i] = tempSmall[i];
			   }
			   temp[wordLength - 1] = c;
		  } else if (overFlag) { /** length has already exceeded 60, using bufferLength judge whether it will overfit. */
			   if (bufferLength == wordLength) {
				    temp = (char *) realloc (temp, sizeof(char) * (wordLength + step + 1));
				    bufferLength = wordLength + step;
			   }
		   	 temp[wordLength++] = c;
		  }
	  }
    else {
    	if (stopFlag == 1) {
    		
    		if (overFlag == 0) {
          tempSmall[wordLength] = '\0';
          // printf("word = %s\n", tempSmall);
          insertData(dictionary, (void *) tempSmall, (void *) tempSmall);
    		} else {
    			temp[wordLength] = '\0';
    			insertData(dictionary, (void *) temp, (void *) temp);
    			free(temp);
    		}
    		stopFlag = 0;
    		overFlag = 0;
        wordLength = 0;
    		memset(tempSmall, 0, sizeof(tempSmall));
    	}
    	
      /** other character: no behavior. */	
    }
  }
  fclose(fp); 
  
}

/*
 * This should process standard input (stdin) and copy it to standard
 * output (stdout) as specified in the spec (e.g., if a standard 
 * dictionary was used and the string "this is a taest of  this-proGram" 
 * was given to stdin, the output to stdout should be 
 * "this is a teast [sic] of  this-proGram").  All words should be checked
 * against the dictionary as they are input, then with all but the first
 * letter converted to lowercase, and finally with all letters converted
 * to lowercase.  Only if all 3 cases are not in the dictionary should it
 * be reported as not found by appending " [sic]" after the error.
 *
 * Since we care about preserving whitespace and pass through all non alphabet
 * characters untouched, scanf() is probably insufficent (since it only considers
 * whitespace as breaking strings), meaning you will probably have
 * to get characters from stdin one at a time.
 *
 * Do note that even under the initial assumption that no word is longer than 60
 * characters, you may still encounter strings of non-alphabetic characters (e.g.,
 * numbers and punctuation) which are longer than 60 characters. Again, for the 
 * final 20% of your grade, you cannot assume words have a bounded length.
 */
void processInput() {
  // -- TODO --
  int c = 0;
  int wordLength = 0;         /* use wordLength to store the length of the word. */
 
  int overFlag = 0;           /* use overFlag to judge whether the length is over 60. */
  int stopFlag = 0;           /* use stopFlag to judge whether the word has ended. */
  int bufferLength = 0;       /* use bufferLength to store the length after resizing. */
  int nextChar = 0;

  char *temp = NULL;
  char tempSmall[61] = {0};

  const int step = 10;        /* resizing step. */
  
  while ((c = myGetch()) != EOF) {

    fprintf(stdout, "%c", c);
    
    if (isalpha(c)) {
      stopFlag = 1;
    
      /** if the word is short, simply using char[61] to store it */
      if (wordLength <= 60) {
        tempSmall[wordLength++] = c;
      } else if (overFlag == 0) {
      
         overFlag = 1;   /** First time to be longer than 60 characters, set overFlag perparing for malloc */
         wordLength++;
         temp = (char *) malloc (sizeof(char) * (wordLength + step + 1));
      
         bufferLength = wordLength + step;

         for (int i = 0; i < wordLength - 1; i++) {
            temp[i] = tempSmall[i];
         }
         temp[wordLength - 1] = c;
      } else if (overFlag) { /** length has already exceeded 60, using bufferLength judge whether it will overfit. */
         if (bufferLength == wordLength) {
            temp = (char *) realloc (temp, sizeof(char) * (wordLength + step + 1));
            bufferLength = wordLength + step;
         }
         temp[wordLength++] = c;
      }
    }

    nextChar = fgetc(stdin);
    if (!isalpha(nextChar)) {
      if (stopFlag == 1) {
        if (overFlag == 0) {
          tempSmall[wordLength] = '\0';
          if (check(tempSmall) == 0) {
            fprintf(stdout, " [sic]");
          }
        } else {
          temp[wordLength] = '\0';
          if (check(temp) == 0) {
            fprintf(stdout, " [sic]");
          }
          free(temp);
        }
        stopFlag = 0;
        overFlag = 0;
        wordLength = 0;
        memset(tempSmall, 0, sizeof(tempSmall));
      }  
    }
    myunGetch(nextChar);
  }
  
}

int check(char * token) {
  if (findData(dictionary, token) == NULL) {
    lowerExceptFirst(token);
    if (findData(dictionary, token) == NULL) {
      token[0] = tolower(token[0]);
      if (findData(dictionary, token) == NULL) {
        return 0;
      }
    }
  }
  return 1;
}

void lowerExceptFirst(char *token) {
  for (int i = 1; i < sizeof(token); i++) {
    token[i] = tolower(token[i]);
  }
}

int myGetch() {
  if (buffer == -1) return fgetc(stdin);
  return buffer;
}

void myunGetch(int c) {
  buffer = c;
}
