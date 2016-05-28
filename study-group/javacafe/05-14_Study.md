# 05-14 스터디모임: 디자인패턴

##싱글톤 패턴
인스턴스가 하나만 만들어지고, 어디서든지 그 인스턴스에 접근할 수 있도록 하기 위한 패턴 (ex. 설정 정보를 저정하고 있는 객체 등에 사용)

```
public class SingletonEx {
    private static SingletonEx instance = null;
    
	// 인스턴스와 생성자 모두 private 으로 접근 제한
	
    private SingletonEx() {
    }

    public static SingletonEx getInstance() {
        if(instance==null)
            return new SingletonEx();
        
        return instance;
    }
}
```

> **<U>멀티스레드 환경에서 Thread safe 하지 않음을 해결하는 방법</U>**
>
> - 객체를 미리 생성 - 한번도 호출하지 않을 경우 메모리 낭비
> - Synchronized 사용 - Synchronized 비용이 비쌈, 자주 호출 되는 경우 성능에 문제 발생
> - DCL(Double Checking Locking) 사용 - Java 1.5이상에서 동작


