# constant-time algorithm

최근 해시 검증 코드를 구현하다 동료분께 배운 타이밍 어택<sup>timing attack</sup>에 관한 재밌는 사례를 정리한다.

개인정보, 비밀번호와 같이 중요한 정보들은 보통 단방향으로 암호화하여 보관한다.
그 이후에는 무언가 요청이 있을 때 평문으로 전송받은 값을 같은 알고리즘으로 암호화하여 보관 된 값과 비교를 수행한다.

SHA-256 알고리즘으로 비밀번호를 해싱한다고 했을 때, 입력 받은 패스워드가 올바른지 다음과 같은 자바 코드로 검증할 수 있다.

```java
public boolean match(String rawPassword, String passwordHash) throws Exception {
    MessageDigest digest = MessageDigest.getInstance("SHA-256");
    byte[] hash = digest.digest(rawPassword.toString().getBytes("UTF-8"));
    StringBuffer hexString = new StringBuffer();

    for (int i = 0; i < hash.length; i++) {
        String hex = Integer.toHexString(0xff & hash[i]);
        if(hex.length() == 1) hexString.append('0');
        hexString.append(hex);
    }

    return hexString.toString().equals(passwordHash);
}
```

여기서 문제는 `equals()`를 통해 비교했다는 점이다. `String` 클래스에서 구현한 `eqauls()` 코드 중 일부를 보면
```java
// 중략

while (n-- != 0) {
    if (v1[i] != v2[i])
    return false;
    i++;
}
```

두 문자열의 한 문자씩 비교하다가 틀리는 즉시 false 를 반환한다. SHA-256 알고리즘으로 해싱할 경우 자릿 수는  64자가 되는데 1번째 문자 비교에서 틀리는지 63번째 문자 비교에서 틀리는지에 따라  응답 시간이 달라 지게 된다.
따라서 공격자는 틀린 비밀번호를 입력했을 응답 받는 시간을 측정할 수 있고 이를 바탕으로 해시값을 추출해 갈 수 있다는 것이다.

# 상수시간 알고리즘<sup>constant-time algorithm</sup>
위 예시와 같은 상황을 방지하기 위해서는 비밀번호 검증에 대해 항상 같은 시간으로 응답하게 해야 한다. 이를 위해 개선 된 코드는 다음과 같다.

```java
public boolean match(CharSequence rawPassword, String encodedPassword) {
    final byte[] rawPasswordBytes = encode(rawPassword).getBytes();
    final byte[] encodedPasswordBytes = encodedPassword.getBytes();

    return match(rawPasswordBytes, encodedPasswordBytes);
}

private boolean match(byte[] expect, byte[] actual) {
    if (actual.length != expect.length) {
        return false;
    }

    int result = 0;

    for(int i = 0 ; i < actual.length ; i++) {
        result |= actual[i] ^ expect[i];
    }

    return result == 0;
}
```

기저사례로 같은 해시 알고리즘의 경우 길이가 같아야 하는데 이를 만족하지 못할 경우 다른 알고리즘으로 해시 되었거나 올바르지 않은 값으로 판단하고 즉시 false 를 반환한다.

다음으로 반복문을 보면 길이만큼 모두 비교를 수행하게 되어 있다. 반복문 내부에서는 논리합<sup>OR</sup>과 베타적 논리합<sup>XOR</sup> 비트 연산을 수행한다.
- 베타적 논리합은 양쪽 비트가 서로 다를 때 결과가 1이 된다. 같으면 0이다.
- 논리합은 양쪽 비트 중 하나라도 1이거나 둘다 1이면 결과가 1이 된다.

따라서 한 비트라도 다르면 `actual[i] ^ expect[i]`의 결과가 1이 될 것이고, 0으로 초기화 된 `result`와 논리합 연산을 수행하면 `result`는 1이 된다. 이렇게 1이 된 `result`는 반복문 내에서 절대 다시 0으로 될 수 없다. 따라서 `result == 0`을 만족하지 못하게 된다.

Spring Security 프로젝트의 `PasswordEncoder`를 봐도 같은 방식으로 구현 되어 있다. ([링크](https://github.com/spring-projects/spring-security/blob/master/crypto/src/main/java/org/springframework/security/crypto/password/AbstractPasswordEncoder.java#L61))

# 참고
- [A Lesson In Timing Attacks (or, Don’t use MessageDigest.isEquals)](https://codahale.com/a-lesson-in-timing-attacks/)
