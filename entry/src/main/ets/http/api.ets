import http, { Result } from './http'

interface IBean {
  time: string,
  ftime: string,
  context: string
}

//https://www.kuaidi100.com/query?type=shunfeng&postid=sf1222
export const testApi = () => {
  return http.post<Result<Array<IBean>>>('query?type=shunfeng&postid=sf1222')
}