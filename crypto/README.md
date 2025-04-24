# 加解密组件
- 该组建目前支持对称加密(AES、3DES、SM4)、非对称加密（RSA、SM2）、消息摘要（SHA、MD5、SM3、HMAC_SHA256）
- 加密结果支持输出Hex/Base64字符串，参见TextFormat.Hex,TextFormat.Base64
- 解密方式支持输入Hex/Base64字符串，参见TextFormat.Hex,TextFormat.Base64
## 对称加密
### AESCrypto
- 密钥算法支持AES128/192/256，参见AESAlgorithm
- 分组模式支持ECB、CBC、CTR、OFB、CFB，参见AESGroupMode
- 填充模式支持NoPadding、PKCS5、PKCS7，参见AESPaddingMode
- 示例：
```javascript
let aes = new AESEncryption(AESAlgorithm.AES256, AESGroupMode.CBC, AESPaddingMode.PKCS7, '0123456789ABCDEF0123456789ABCDEF', '0123456789ABCDEF', TextFormat.HEX, TextFormat.HEX)
let encryptResult = await aes.encrypt('这是一条待加密的信息lllllllll');
console.info(`>>>>>> cipherText:${encryptResult}`)
let decryptResult = await aes.decrypt(encryptResult ?? '');
console.info(`>>>>>> plainText:${decryptResult}`)
```

### TripleDesCrypto
- 密钥算法支持3DES192，参见TripleDesAlgorithm
- 分组模式支持ECB、CBC、OFB、CFB，参见TripleDesGroupMode
- 填充模式支持NoPadding、PKCS5、PKCS7，参见TripleDesPaddingMode
- 示例：
```javascript
let tripleDes = new TripleDesCrypto(TripleDesAlgorithm.TripleDes192, TripleDesGroupMode.CBC, TripleDesPaddingMode.PKCS7, '0123456789ABCDEF01234567', '01234567', TextFormat.HEX, TextFormat.HEX)
let encryptResult2 = await tripleDes.encrypt('这是一条待加密的信息llllll');
console.info(`>>>>>> cipherText:${encryptResult2}`)
let decryptResult2 = await tripleDes.decrypt(encryptResult2 ?? '');
console.info(`>>>>>> plainText:${decryptResult2}`)
```

### SM4Crypto
- 密钥算法支持SM4_128，参见SM4Algorithm
- 分组模式支持ECB、CBC、CTR、OFB、CFB、CFB128，参见SM4GroupMode
- 填充模式支持NoPadding、PKCS5、PKCS7，参见SM4PaddingMode
```javascript
let sm4 = new SM4Crypto(SM4Algorithm.SM4_128, SM4GroupMode.CTR, SM4PaddingMode.PKCS7, '0123456789ABCDEF', '0123456789ABCDEF', TextFormat.HEX, TextFormat.HEX)

let encryptResult3 = await sm4.encrypt('这是一条待加密的信息llllll这是一条待加密的信息llllll');
console.info(`>>>>>> cipherText:${encryptResult3}`)
let decryptResult3 = await sm4.decrypt(encryptResult3 ?? '');
console.info(`>>>>>> plainText:${decryptResult3}`)
```

### XXTEA
示例：
```javascript
    let xxtea = new XXTEACrypto('FEDCBA9876543210', TextFormat.BASE64, TextFormat.BASE64)
    let encryptResult = await xxtea.encrypt('这是一条待加密的信息llllll这是一条待加密的信息llllll')
    console.info(`>>>>>> cipherText:${encryptResult}`)
    let decryptResult = await xxtea.decrypt(encryptResult ?? '');
    console.info(`>>>>>> plainText:${decryptResult}`)
```


## 非对称加密
### RSA
- 密钥算法支持RSA512/768/1024/2048/4096/8192，参见RSAAlgorithm
- 填充模式支持PKCS1，参见RSAPaddingMode
```javascript
let rsa = new RSACrypto(RSAAlgorithm.RSA1024,
RSAPaddingMode.PKCS1,
'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCn8gpcq07N07rEiOvrMeflyBuayFdgoFqYAynJCohCcaVF/oOyCdfKquDhiWELBrxFxg3R9dF7edeoGKpCIg+REbArJekNdDadYp9bGPBMyMzySCowu4LOQF9/tpSSuBKJ6ZCBFle5q2yksTAYv1Yz6cnIRBieD+6pyHoltpSSAQIDAQAB',
'MIICXAIBAAKBgQCn8gpcq07N07rEiOvrMeflyBuayFdgoFqYAynJCohCcaVF/oOyCdfKquDhiWELBrxFxg3R9dF7edeoGKpCIg+REbArJekNdDadYp9bGPBMyMzySCowu4LOQF9/tpSSuBKJ6ZCBFle5q2yksTAYv1Yz6cnIRBieD+6pyHoltpSSAQIDAQABAoGADnjpkq3CdzMxK4F/Dv/4c1Eoq9Bq0y1OUT4oiiYJsuwXKW5yy9NUUKckBNtxTOFyNPMJutebiy/nORmTBmrn+10T4eSqjOgfMD9J1l0BijnZbuirM00KYmKMVP0En/UZlI6yrHZjimhaf5k0afIStwqhE13CDOXQWjEWQtWhSSECQQDTrgo3XaoJbTNYPoz8EJ1PJAhJBmN0+FOi2K2GbKAPgopw0Vrw85L7gLc3+GMVIhY0Rw6IxlkhRIpMqTzhLmnJAkEAyxvayCFKaPJUjiXkZkRgBGJqHd5V1+HsazkxLvjrWaRA0xnkWNcjrXSTk0gcuQTmXlBAQWNUMSEdCeG6/MkCeQJAT5rV0Lhyp5TfiEINtwVwg0CjtQKoCGcS3NzrdPAIyYxoD8FLl+2hyt8/B9drO5lUDFjkiF8/SZmDAQ1sDarssQJBAIcIbs0NLP5W1hZnZNEE9l0T3P8cmS/c2SR0MpnLDhVb2Wk/1oumBOdGEPMjR01Oz6W2bvHKCuha3oZ6V6nGLekCQGaX6iOFEqSX20aGyfdLorYg1HdLqyNyLW7UMuXFl/ZRBG1xGiUxVfGfDh5hAz5E7gnS/lwzPlUYl8VDsF++ktQ=')
let encryptResult = await rsa.encrypt('这是一条待加密的信息llllll这是一条待加密的信息llllll')
console.info(`>>>>>> cipherText:${encryptResult}`)
let decryptResult = await rsa.decrypt(encryptResult ?? '');
console.info(`>>>>>> plainText:${decryptResult}`)
```

### SM2
- 目前测试有问题，暂不支持

## 消息摘要
目前支持SHA1、SHA224、SHA256、SHA384、SHA512、MD5、SM3、HMAC_SHA256(目前仅支持16、24、32密钥长度)，参见DigestAlgorithm
```javascript
console.log('>>>>>>>>>>sha1:' + await DigestAlgorithm.SHA1('这是一条待加密的信息llllll这是一条待加密的信息llllll'))
console.log('>>>>>>>>>>sha224:' + await DigestAlgorithm.SHA224('这是一条待加密的信息llllll这是一条待加密的信息llllll'))
console.log('>>>>>>>>>>sha256:' + await DigestAlgorithm.SHA256('这是一条待加密的信息llllll这是一条待加密的信息llllll'))
console.log('>>>>>>>>>>sha384:' + await DigestAlgorithm.SHA384('这是一条待加密的信息llllll这是一条待加密的信息llllll'))
console.log('>>>>>>>>>>sha512:' + await DigestAlgorithm.SHA512('这是一条待加密的信息llllll这是一条待加密的信息llllll'))
console.log('>>>>>>>>>>md5:' + await DigestAlgorithm.MD5('这是一条待加密的信息llllll这是一条待加密的信息llllll'))
console.log('>>>>>>>>>>sm3:' + await DigestAlgorithm.SM3('这是一条待加密的信息llllll这是一条待加密的信息llllll'))
console.log('>>>>>>>>>>HMAC_SHA256:' + await DigestAlgorithm.HMAC_SHA256('这是一条待加密的信息llllll这是一条待加密的信息llllll', '0123456789ABCDEF0123456789ABCDEF'))
```



