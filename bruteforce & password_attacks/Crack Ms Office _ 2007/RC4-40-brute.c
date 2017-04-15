/* Program to brute-force RC4 40-bit keyspace by Dhiru Kholia.
 *
 * common_init is part of John the Ripper password cracker,
 * Copyright (c) 1996-99 by Solar Designer */

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "rc4.h"
#include <openssl/md5.h>
#include <omp.h>
#include <sys/time.h>
#include <time.h>

#define ARCH_INDEX(x)			((unsigned int)(unsigned char)(x))

char itoa64[64] =
	"./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
char atoi64[0x100];

char itoa16[16] =
	"0123456789abcdef";
char itoa16u[16] =
	"0123456789ABCDEF";
char atoi16[0x100];

static int initialized = 0;

void common_init(void)
{
	char *pos;

	if (initialized) return;

	memset(atoi64, 0x7F, sizeof(atoi64));
	for (pos = itoa64; pos <= &itoa64[63]; pos++)
		atoi64[ARCH_INDEX(*pos)] = pos - itoa64;

	memset(atoi16, 0x7F, sizeof(atoi16));
	for (pos = itoa16; pos <= &itoa16[15]; pos++)
		atoi16[ARCH_INDEX(*pos)] = pos - itoa16;

	atoi16['A'] = atoi16['a'];
	atoi16['B'] = atoi16['b'];
	atoi16['C'] = atoi16['c'];
	atoi16['D'] = atoi16['d'];
	atoi16['E'] = atoi16['e'];
	atoi16['F'] = atoi16['f'];

	initialized = 1;
}

#define PLAINTEXT_LENGTH	32
#define BINARY_SIZE		16
#define MIN_KEYS_PER_CRYPT	1
#define MAX_KEYS_PER_CRYPT	1

int type;
unsigned char salt[16];
unsigned char verifier[16];
unsigned char verifierHash[16];

static void print_hex(unsigned char *str, int len)
{
	int i;
	for (i = 0; i < len; ++i)
		printf("%02x", str[i]);
	printf("\n");
}

static inline void try_key(unsigned char *hashBuf)
{
	MD5_CTX ctx;
	unsigned char pwdHash[16];
	unsigned char rc4Key[16];
	unsigned char out[32];
	RC4_KEY key;

	MD5_Init(&ctx);
	MD5_Update(&ctx, hashBuf, 9);
	MD5_Final(pwdHash, &ctx);
	memcpy(rc4Key, pwdHash, 16); /* 128-bit key */
	RC4_set_key(&key, 16, rc4Key);
	RC4(&key, 16, verifier, out); /* encryptedVerifier*/
	RC4(&key, 16, verifierHash, out + 16); /* encryptedVerifierHash */
	/* hash the decrypted verifier */
	MD5_Init(&ctx);
	MD5_Update(&ctx, out, 16);
	MD5_Final(pwdHash, &ctx);
	if(!memcmp(pwdHash, out + 16, 16)) {
		printf("Key is : " );
		print_hex(hashBuf, 5);
		exit(0);
	}
}


void keyspace_search()
{
	char buffer[30];
	struct timeval tv;
	time_t curtime;

	int i, j, k;
	int is = 0x00;
	int js = 0x00;
	int ks = 0x00;
	int ls = 0x00;
	int ms = 0x00;

	/* 69a3aea22c is key for test.doc */
	/* int is = 0x69;
	int js = 0xa3;
	int ks = 0x00;
	int ls = 0x00;
	int ms = 0x00; */

	for(i = is; i <= 255; i++) { /* time = 256 * 9 * 256 seconds ~= 6.83 days */
		for(j = js; j <= 255; j++) {
			/* takes 8.5 seconds on AMD X3 (using all cores) for one tick */
			/* takes 3 seconds on AMD FX-8120 (using all cores) for one tick */
			gettimeofday(&tv, NULL);
			curtime=tv.tv_sec;
			printf("%d %d @ ", i, j);
			strftime(buffer,30,"%m-%d-%Y  %T.",localtime(&curtime));
			printf("%s%ld\n",buffer,tv.tv_usec);
			fflush(stdout);
#pragma omp parallel for
			for(k = ks; k <= 255; k++) {
				int l, m;
				for(l = ls; l <= 255; l++) {
					for(m = ms; m <= 255; m++) {
						unsigned char hashBuf[9] = { 0 };
						hashBuf[0] = (char)i;
						hashBuf[1] = (char)j;
						hashBuf[2] = (char)k;
						hashBuf[3] = (char)l;
						hashBuf[4] = (char)m;
						try_key(hashBuf);
					}
				}
			}
		}
	}
}

int main(int argc, char **argv)
{
	int i;

	if(argc < 2) {
		fprintf(stderr, "Usage: %s <hash given by office2john.py program>\n\n", argv[0]);
		fprintf(stderr, "Example: %s \'test.doc:$oldoffice$1*de17a7f3c3ff03a39937ba9666d6e952*2374d5b6ce7449f57c9f252f9f9b53d2*e60e1185f7aecedba262f869c0236f81\'\n", argv[0]);
		exit(-1);
	}

	common_init();

	char *ctcopy = strdup(argv[1]);
	char *keeptr = ctcopy;
	char *p;
	ctcopy = strchr(ctcopy, ':') + 1 + 11; /* skip over filename and "$oldoffice$" */
	p = strtok(ctcopy, "*");
	type = atoi(p);
	if (!(type < 3)) {
		fprintf(stderr, "Only documents encrypted using RC4 40-bit are supported!\n");
		exit(-1);
	}

	p = strtok(NULL, "*");
	for (i = 0; i < 16; i++)
		salt[i] = atoi16[ARCH_INDEX(p[i * 2])] * 16
			+ atoi16[ARCH_INDEX(p[i * 2 + 1])];
	p = strtok(NULL, "*");
	for (i = 0; i < 16; i++)
		verifier[i] = atoi16[ARCH_INDEX(p[i * 2])] * 16
			+ atoi16[ARCH_INDEX(p[i * 2 + 1])];
	p = strtok(NULL, "*");
	if(type < 3) {
		for (i = 0; i < 16; i++)
			verifierHash[i] = atoi16[ARCH_INDEX(p[i * 2])] * 16
				+ atoi16[ARCH_INDEX(p[i * 2 + 1])];
	}
	free(keeptr);
	print_hex(verifierHash, 16);

	keyspace_search();
	return 0;
}

