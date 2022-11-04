#include <time.h>
#include <stdio.h>
#include <x86intrin.h>
#include "common.h"

long long int sum(unsigned int vals[NUM_ELEMS]) {
	clock_t start = clock();

	long long int sum = 0;
	for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
		for(unsigned int i = 0; i < NUM_ELEMS; i++) {
			if(vals[i] >= 128) {
				sum += vals[i];
			}
		}
	}
	clock_t end = clock();
	printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
	return sum;
}

long long int sum_unrolled(unsigned int vals[NUM_ELEMS]) {
	clock_t start = clock();
	long long int sum = 0;

	for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
		for(unsigned int i = 0; i < NUM_ELEMS / 4 * 4; i += 4) {
			if(vals[i] >= 128) sum += vals[i];
			if(vals[i + 1] >= 128) sum += vals[i + 1];
			if(vals[i + 2] >= 128) sum += vals[i + 2];
			if(vals[i + 3] >= 128) sum += vals[i + 3];
		}

		//This is what we call the TAIL CASE
		//For when NUM_ELEMS isn't a multiple of 4
		//NONTRIVIAL FACT: NUM_ELEMS / 4 * 4 is the largest multiple of 4 less than NUM_ELEMS
		for(unsigned int i = NUM_ELEMS / 4 * 4; i < NUM_ELEMS; i++) {
			if (vals[i] >= 128) {
				sum += vals[i];
			}
		}
	}
	clock_t end = clock();
	printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
	return sum;
}

long long int sum_simd(unsigned int vals[NUM_ELEMS]) {
	clock_t start = clock();
	__m128i _127 = _mm_set1_epi32(127);		// This is a vector with 127s in it... Why might you need this?
	long long int result = 0;				   // This is where you should put your final result!
	/* DO NOT DO NOT DO NOT DO NOT WRITE ANYTHING ABOVE THIS LINE. */
	
	for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
		/* YOUR CODE GOES HERE */
		int sum[4];
		__m128i sum_num = _mm_loadu_si128((__m128i *) &(sum[0]));
		sum_num = _mm_setzero_si128();
		for (unsigned i = 0; i < NUM_ELEMS / 4 * 4; i += 4) {
			int temp[4];
			temp[0] = vals[i];
			temp[1] = vals[i + 1];
			temp[2] = vals[i + 2];
			temp[3] = vals[i + 3];
			__m128i temp_num = _mm_loadu_si128((__m128i *) &(temp[0]));
			__m128i test_mask = _mm_cmpgt_epi32(temp_num, _127);
			sum_num = _mm_add_epi32(_mm_and_si128(temp_num, test_mask), sum_num);
		}
		/* You'll need a tail case. */
		_mm_storeu_si128((__m128i *) &(sum[0]), sum_num);
		for (int i = 0; i < 4; i++) {
			result += sum[i];
		}
		for(unsigned int i = NUM_ELEMS / 4 * 4; i < NUM_ELEMS; i++) {
			if (vals[i] >= 128) {
				result += vals[i];
			}
		}
	}
	clock_t end = clock();
	printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
	return result;
}

long long int sum_simd_unrolled(unsigned int vals[NUM_ELEMS]) {
	clock_t start = clock();
	__m128i _127 = _mm_set1_epi32(127);
	long long int result = 0;
	for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
		/* COPY AND PASTE YOUR sum_simd() HERE */
		/* MODIFY IT BY UNROLLING IT */
		int sum[4];
		__m128i sum_num = _mm_loadu_si128((__m128i *) &(sum[0]));
		sum_num = _mm_setzero_si128();
		for (unsigned i = 0; i < NUM_ELEMS / 8 * 8; i += 8) {
			int temp[4];
			temp[0] = vals[i];
			temp[1] = vals[i + 1];
			temp[2] = vals[i + 2];
			temp[3] = vals[i + 3];
			__m128i temp_num_1 = _mm_loadu_si128((__m128i *) &(temp[0]));
			__m128i test_mask_1 = _mm_cmpgt_epi32(temp_num_1, _127);
			sum_num = _mm_add_epi32(_mm_and_si128(temp_num_1, test_mask_1), sum_num);
			temp[0] = vals[i + 4];
			temp[1] = vals[i + 5];
			temp[2] = vals[i + 6];
			temp[3] = vals[i + 7];
			__m128i temp_num_2 = _mm_loadu_si128((__m128i *) &(temp[0]));
			__m128i test_mask_2 = _mm_cmpgt_epi32(temp_num_2, _127);
			sum_num = _mm_add_epi32(_mm_and_si128(temp_num_2, test_mask_2), sum_num);
		}
		/* You'll need a tail case. */
		_mm_storeu_si128((__m128i *) &(sum[0]), sum_num);
		for (int i = 0; i < 4; i++) {
			result += sum[i];
		}
		for(unsigned int i = NUM_ELEMS / 8 * 8; i < NUM_ELEMS; i++) {
			if (vals[i] >= 128) {
				result += vals[i];
			}
		}
		/* You'll need 1 or maybe 2 tail cases here. */

	}
	clock_t end = clock();
	printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
	return result;
}