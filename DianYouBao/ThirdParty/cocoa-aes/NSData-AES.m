//
//  NSData-AES.m
//  Encryption
//
//  Created by Jeff LaMarche on 2/12/09.
//  Copyright 2009 Jeff LaMarche Consulting. All rights reserved.
//

#import "NSData-AES.h"
#import "rijndael.h"

@implementation NSDataAES

+ (NSData *)AESEncryptData: (NSData *) data WithPassphrase:(NSString *)pass
{
	NSMutableData *ret = [NSMutableData dataWithCapacity:[data length]];
	unsigned long rk[RKLENGTH(KEYBITS)];
	unsigned char key[KEYLENGTH(KEYBITS)];
	const char *password = [pass UTF8String];
	
    int i = 0;
	for (i = 0; i < sizeof(key); i++)
		key[i] = password != 0 ? *password++ : 0;
	
	int nrounds = rijndaelSetupEncrypt(rk, key, KEYBITS);
	
	unsigned char *srcBytes = (unsigned char *)[data bytes];
	int index = 0;
	
	while (1) 
	{
		unsigned char plaintext[16];
		unsigned char ciphertext[16];
		int j;
		for (j = 0; j < sizeof(plaintext); j++)
		{
			if (index >= [data length])
				break;
			
			plaintext[j] = srcBytes[index++];
		}
		if (j == 0)
			break;
		for (; j < sizeof(plaintext); j++)
		{
			//plaintext[j] = ' ';	// xw
			plaintext[j] = '\0';
		}
		rijndaelEncrypt(rk, nrounds, plaintext, ciphertext);
		[ret appendBytes:ciphertext length:sizeof(ciphertext)];
	}
	return ret;
}

+ (NSData *)AESDecryptData: (NSData *) data WithPassphrase:(NSString *)pass
{
	NSMutableData *ret = [NSMutableData dataWithCapacity:[data length]];

	unsigned long rk[RKLENGTH(KEYBITS)];
	unsigned char key[KEYLENGTH(KEYBITS)];
	const char *password = [pass UTF8String];
    
    int i = 0;
	for (i = 0; i < sizeof(key); i++)
		key[i] = password != 0 ? *password++ : 0;

	int nrounds = rijndaelSetupDecrypt(rk, key, KEYBITS);
	unsigned char *srcBytes = (unsigned char *)[data bytes];
	int index = 0;
	while (index < [data length])
	{
		unsigned char plaintext[16];
		unsigned char ciphertext[16];
		int j;
		for (j = 0; j < sizeof(ciphertext); j++)
		{
			if (index >= [data length])
				break;
			
			ciphertext[j] = srcBytes[index++];
		}
		rijndaelDecrypt(rk, nrounds, ciphertext, plaintext);

		[ret appendBytes:plaintext length:sizeof(plaintext)];
		
	}

	return ret;
}

@end
