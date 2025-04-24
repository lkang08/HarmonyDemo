import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';
import { TextFormat } from '@slink/crypto/src/main/ets/CryptoStandardDefine';

const aesKey = "cZP1VQZUcwfp4mxFpXGP1x22oUFRL9aP";
const aesIv = "J5VaZ4fNZY87YgXR";

function generateRandom(len: number) {
  let rand = cryptoFramework.createRandom();
  let generateRandSync = rand.generateRandomSync(len);
  return generateRandSync;
}

function genGcmParamsSpec() {
  //let ivBlob = generateRandom(12);
  //let iv = new Uint8Array(buffer.from(aesIv, TextFormat.BASE64).buffer)
  let iv = new Uint8Array(buffer.from(aesIv, 'utf-8').buffer)
  let ivBlob: cryptoFramework.DataBlob = { data: iv };
  let arr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; // 16 bytes
  let dataTag = new Uint8Array(arr);
  let tagBlob: cryptoFramework.DataBlob = {
    data: dataTag
  };
  // GCM的authTag在加密时从doFinal结果中获取，在解密时填入init函数的params参数中
  let gcmParamsSpec: cryptoFramework.GcmParamsSpec = {
    iv: ivBlob,
    aad: { data: new Uint8Array() },
    authTag: tagBlob,
    algName: "GcmParamsSpec"
  };
  return gcmParamsSpec;
}

let gcmParams = genGcmParamsSpec();

// 加密消息
function encryptMessage(symKey: cryptoFramework.SymKey, plainText: cryptoFramework.DataBlob) {
  let cipher = cryptoFramework.createCipher('AES256|GCM|PKCS7');
  cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, gcmParams);
  /*let encryptUpdate = cipher.updateSync(plainText);
  //gcm模式加密doFinal时传入空，获得tag数据，并更新至gcmParams对象中。
  gcmParams.authTag = cipher.doFinalSync(null);*/
  let encryptUpdate = cipher.doFinalSync(plainText)
  console.info('encryptMessage authTag: ' + buffer.from(gcmParams.authTag.data).toString(TextFormat.BASE64));
  return encryptUpdate;
}

// 解密消息
function decryptMessage(symKey: cryptoFramework.SymKey, cipherText: cryptoFramework.DataBlob) {
  let decoder = cryptoFramework.createCipher('AES256|GCM|PKCS7');
  let length = cipherText.data.length
  if (length > 16) {
    let tag = cipherText.data.subarray(length - 16) //java的aes gcm算法加密结果是密文+authTag，authTag 16字节
    gcmParams.authTag = {data: tag}
    cipherText.data = cipherText.data.subarray(0, length - 16)
  }
  decoder.initSync(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, gcmParams);
  let decryptUpdate = decoder.updateSync(cipherText);
  let temp = gcmParams.authTag
  console.info('###########decrypt plainText: ' + buffer.from(decryptUpdate.data).toString('utf-8'));
  // gcm模式解密doFinal时传入空，验证init时传入的tag数据，如果验证失败会抛出异常。
  let decryptData = decoder.doFinalSync(null);
  if (decryptData == null) {
    console.info('GCM decrypt success, decryptData is null');
  }
  return decryptUpdate;
}

function genSymKeyByData(symKeyData: Uint8Array) {
  let symKeyBlob: cryptoFramework.DataBlob = { data: symKeyData };
  let aesGenerator = cryptoFramework.createSymKeyGenerator('AES256');
  let symKey = aesGenerator.convertKeySync(symKeyBlob);
  console.info('convertKeySync success');
  return symKey;
}

let testmsg = 'RYNblRfSa2T+IAdS2LkPDIivk+U48GhjsdddXSl63ZFLihR20eKHSHYW55ldSzr9wS9BJY2aDQuoAz2vhrTErAKEQrL5Ivs6sQmtVNrifD6Qflk/azbUdZikISdbF1M9DDtOpgFbMOzkPR+UXOAHwUaTg7hDhOWcca44eEyjHI77y6YDxib1PAtMQuUzyyYw0y0jOwcdV/VjylUe+vSp8GgaB5nQ+mL/oBEsQrrUzSJK3xaVmHVvH1mWVrqTV4NPDHfKd5vl8ysI+t8n9rDIeh4cFe2RlaeQaS48xSEyLW/VN9Rt81JjNIFJFKMJOYIMtKSJlpLhCPL1uQjp0/PX3vvyRI9GGQ+IPgcvQOyP4UWpx/lJN6AAHTZktJyRq3lF0Ej+5aXs0//Hmu52HtlLEexa5UudUwSEIlGW2C3q03tInGZsaq9tcW4NnWH155TGlVBVXsY0+7WObjfobyUBSL/yN+TsOJsuG6lRo0d/K5O6GX1Kdf7YBtCUSY8CXe1c0dF3fGXaL/bPgHW83cg/9IZgC1nD25JuntM2wm5WGg/z9QdF/2Xvd/w3xQvthU/Z4mdlVhu+k3yigg83F3H8Arb+pXg21HIskePTYwTbNwEwnYXPNAIVL1cZwr2GloDCTh02/ofxSE287Zo0cZiBRQiDQjjcxf/nEDs2T/3eYMP0OoMDuruoRcRAdSc1VMbuhQlW0dvzoczP8Cq49ue2ENa7I/RFfLiPug6avV+vAshVUQAP75VUmrv34M0gM47Y6Kiv6Sz6SaVnbjeujX1jczxF8QXTyG7vnQ=='
export function aesMain() {
  let originalData = '{"userNameEncrypt":1,"phoneEncrypt":1}'
  originalData = '{}'
  let keyData = new Uint8Array(buffer.from(aesKey, 'utf-8').buffer)
  let symKey = genSymKeyByData(keyData);
  let plainText: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from(originalData, 'utf-8').buffer) };
  let encryptText = encryptMessage(symKey, plainText);
  console.info('encryptText encryptText: ' + buffer.from(encryptText.data).toString(TextFormat.BASE64));

  //testmsg = buffer.from(encryptText.data).toString(TextFormat.BASE64)
  let array = new Uint8Array(buffer.from(testmsg, TextFormat.BASE64).buffer)
  if (array.length > 16) {
    //array = array.subarray(0, array.length - 16)
  }
  let dect: cryptoFramework.DataBlob = {data: array}
  let decryptText = decryptMessage(symKey, dect);
  console.info('decrypt plainText: ' + buffer.from(decryptText.data).toString('utf-8'));

  let rand = cryptoFramework.createRandom();
  let generateRandSync = rand.generateRandomSync(16);
  console.info('###########: ' + buffer.from(generateRandSync.data).toString(TextFormat.BASE64));
  console.info('###########: ' + buffer.from(generateRandSync.data).toString('utf-8'));
  console.info('###########: ' + buffer.from(generateRandSync.data).toString(TextFormat.HEX));
}