/**
 * AES算法
 */
export enum AESAlgorithm {
  AES128 = 'AES128',
  AES192 = 'AES192',
  AES256 = 'AES256',
}

/**
 * 分组模式
 */
export enum AESGroupMode {
  ECB = 'ECB',
  CBC = 'CBC',
  CTR = 'CTR',
  OFB = 'OFB',
  CFB = 'CFB',
  // GCM = 'GCM', //暂不支持
  // CCM = 'CCM'
}

/**
 * 填充模式，对于CFB、OFB、CTR、GCM、CCM这类将分组密码转化为流模式实现的模式，不需要填充，因此无论是否指定填充模式，都会按照NoPadding实现。
 */
export enum AESPaddingMode {
  NoPadding = 'NoPadding',
  PKCS5 = 'PKCS5',
  PKCS7 = 'PKCS7'
}


/**
 * 3DES算法
 */
export enum TripleDesAlgorithm {
  TripleDes192 = '3DES192',
}

/**
 * 分组模式
 */
export enum TripleDesGroupMode {
  ECB = 'ECB',
  CBC = 'CBC',
  OFB = 'OFB',
  CFB = 'CFB'
}

/**
 * 填充模式，对于CFB、OFB、CTR、GCM、CCM这类将分组密码转化为流模式实现的模式，不需要填充，因此无论是否指定填充模式，都会按照NoPadding实现。
 */
export enum TripleDesPaddingMode {
  NoPadding = 'NoPadding',
  PKCS5 = 'PKCS5',
  PKCS7 = 'PKCS7'
}


/**
 * SM4算法
 */
export enum SM4Algorithm {
  SM4_128 = 'SM4_128'
}

/**
 * 分组模式
 */
export enum SM4GroupMode {
  ECB = 'ECB',
  CBC = 'CBC',
  CTR = 'CTR',
  OFB = 'OFB',
  CFB = 'CFB',
  CFB128 = 'CFB128'
}

/**
 * 填充模式，对于CFB、OFB、CTR、GCM、CCM这类将分组密码转化为流模式实现的模式，不需要填充，因此无论是否指定填充模式，都会按照NoPadding实现。
 */
export enum SM4PaddingMode {
  NoPadding = 'NoPadding',
  PKCS5 = 'PKCS5',
  PKCS7 = 'PKCS7'
}

/**
 * RSA密钥类型
 */
export enum RSAAlgorithm {
  RSA512 = 'RSA512',
  RSA768 = 'RSA768',
  RSA1024 = 'RSA1024',
  RSA2048 = 'RSA2048',
  RSA3072 = 'RSA3072',
  RSA4096 = 'RSA4096',
  RSA8192 = 'RSA8192',
  RSA = 'RSA'
}

/**
 * 填充模式
 */
export enum RSAPaddingMode {
  PKCS1 = 'PKCS1',
  // PKCS1_OAEP = 'PKCS1_OAEP'  //暂不支持
}

/**
 * SM2密钥类型
 */
export enum SM2Algorithm {
  SM2_256 = 'SM2_256',
  SM2 = 'SM2'
}

/**
 * SM2摘要算法
 */
export enum SM2DigestAlgorithm{
  MD5 = 'MD5',
  SHA1 = 'SHA1',
  SHA224 = 'SHA224',
  SHA256 = 'SHA256',
  SHA384 = 'SHA384',
  SHA512 = 'SHA512',
  SM3 = 'SM3'
}

/**
 * 消息摘要算法
 */
export enum HASHAlgorithm {
  SHA1 = 'SHA1',
  SHA224 = 'SHA224',
  SHA256 = 'SHA256',
  SHA384 = 'SHA384',
  SHA512 = 'SHA512',
  MD5 = 'MD5',
  SM3 = 'SM3'
}

/**
 * 文本格式，输入仅支持HEX & BASE64
 */
export enum TextFormat {
  HEX = 'hex',
  BASE64 = 'base64'
}

export enum InnerTextFormat {
  UTF8 = 'utf-8',
}