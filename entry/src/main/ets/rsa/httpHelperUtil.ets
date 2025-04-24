import { HashMap } from '@kit.ArkTS';
import { DigestAlgorithm } from '@slink/crypto';
import { RSA_PUBLIC_KEY } from './resUtil';

function genReqParams(encryptedAesKeyBase64String: string, encryptedBodyBase64String: string) {

  return ''
}

export async function generateSignature(sigParam: HashMap<string, string>) {
  /*let keys = Array.from(sigParam.keys()).sort((a, b) => {
    return a.localeCompare(b)
  })*/
  let keys = ['Authorization','X-ENTRY-KEY','X-NONCE','X-TIMESTAMP','body']
  let sb = ''
  keys.forEach((v: string, index: number) => {
    sb += v + sigParam.get(v)
  })
  //let rsaKey = StringUtils.base64ToString(RSA_PUBLIC_KEY)
  let signature = await DigestAlgorithm.HMAC_SHA256_NEW(sb, RSA_PUBLIC_KEY)
  return signature ?? ''
}
