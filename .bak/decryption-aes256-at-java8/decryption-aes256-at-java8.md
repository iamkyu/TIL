# decryption-aes256-at-java8
## 증상
AES256 암호화 알고리즘으로 암호화 된 값을 복호화 시도시 `javax.crypto.Cipher` 클래스의 `void checkCryptoPerm(CipherSpi var1, Key var2, AlgorithmParameterSpec var3)` 메서드에서 `passCryptoPermCheck` 에 실패하고 `java.security.InvalidKeyException: Illegal key size` 발생.
하지만 동료분 머신 및 Production 환경에서는 잘 동작. 

## 원인
검색 결과를 종합해보면, 미 통상법에 의해 미국내에서만 AES256 암호화 알고리즘 사용 가능. 따라서 자바 기본 정책은 AES128 암호화 알고리즘 사용. 
256 암호화 알고리즘을 사용하고 싶으면 버전별로 다음 과정이 필요.
- 8u151 이하 버전에서는 Policy Files 을 받아서 덮어써야 함.
- 8u152 이상 버전에서는 자바 코드 또는 프로퍼티 파일 수정을 통해 사용 가능.
- 8u162 이상 버전부터는 별도의 조치 없이 사용 가능.

## 해결
내 로컬 머신은 8u181 이기에 별도의 조치가 불필요함에도 불구하고 위 내용을 모두 적용해도 같은 증상 발생.
원인은 사용하는 IDE (나의 경우 IntelliJ) 에서  JDK Home 을 하위 버전으로 지정되어 있었음.
- Project Structure > Platform Settings > SDKs 에서 사용하는 버전의 JDK Home path 확인.

## 참고
[AES256 암호화 오류 해결 :: Turning Point](https://mirotic91.tistory.com/21)
