# Java Performance Fundamental

> 김한도 저. 엑셈 출판. 2009.

## CH1. JVM
> Write Once, Run Everywhere

자바의 철학을 수행하기 위한 네 가지 기술
- The Java Programming Language
- The Java Class File Format
- The Java Application Programming Interface (Java API)
- The Java Virtual Machine (JVM)

### The Java Class File Format
- `.class` 파일은 실행 가능한 형태가 아닌 JVM  이 읽을 수 있는 형태로 번역 된 것. 
- 클래스 파일은 실행시 Link 할 수 있도록 Symbolic Reference 만을 가지고 있음. 
- 런타임 시점에 메모리상 실제로 존재하는 물리적 주소로 대체 작업인 Linking 이 일어남.
- 이 기술로 클래스 파일의 크기를 작게 유지 가능함.
- Symbolic Reference 는  자바 코드 상에서 어떠한 메모리 주소를 언급하지 않고 객체 이름으로 참조를 구성하는 것을 의미함

#### 클래스 파일의 네 가지 특징
- Compact (Dynamic Linking 덕분)
- Bytecode (즉, 사람이 읽을 수 있는 언어 -> JVM 이 읽을 수 있는 언어)
- Network Byte Order 의 사용 (서로 다른 계열의 CPU 끼리 데이터를 전송 받을 때의 문제점을 해결)
- Platform 독립적

### The Java Application Programming Interface
 - Runtime Library 의 집합
 - OS 시스템과 자바 프로그램 사이를 이어주는 일종의 가교 역할
 - 예컨대, 파일을 읽기 위해 `java.io.InputStream` 클래스를 사용하면 런타임시 해당 API 의 Symbolic Reference 를 이용해 해당 인스턴스 접근. 실제 파일에 대한 접근은 Native Method 를 통해 OS 에 명령을 전달.

### The Java Virtual Machine
- JVM 은 하나의 개념, 스펙에 지나지 않음.
- 따라서 정통 JVM 이란 것은 없음. 정의된 스펙을 구현한 하나의 독자적인 Runtime Instance.
- JVM Specs https://docs.oracle.com/javase/specs/jvms/se7/html/


## CH2. Runtime Data Areas
- Process 로서 JVM 이 프로그램을 수행하기 위해 OS 로부터 할당 받은 메모리 영역.
- Runtime Data Areas 도 스펙에 지나지 않음. 
- PC Registers, Java Virtual Machine Stacks, Native Method Stacks 는 스레드별 존재.
- Method Area, Heap 은 모든 스레드 공유.

![Runtime Data Areas](https://user-images.githubusercontent.com/13076271/60509496-fdce5300-9d07-11e9-9c77-800655656308.jpg)
> 출처: http://www.herongyang.com/JVM/Data-Area-What-Are-Runtime-Data-Areas.html

### PC Registers
- CPU Instruction 을 수행하는 과정에서 필요한 정보를 저장하기 위한 Stack-Base 메모리 영역.
- JVM 도 머신 위에서 동작하는 하나의 프로세스에 지나지 않기 때문에 머신의 리소스는 사용해야 하고, 자바의 철학인 플랫폼 독립성을 취하기 위한 JVM 의 CPU 레지스터.
- C 언어 등으로 Native Method (또는 Function) 를 수행하고 있다면 PC Register 는 undefined 상태임.
- PC Register 에 저장 된 Instruction 주소는 Native Pointer 또는 Method Byte code 의 시작점.

### Java Virtual Machine Stacks
- 스레드의 수행 정보를 기록하는 Frame 을 저장하는 메모리 영역.
- `kill -3 pid` 로 Dump 하는 정보가 바로 이 영역의 Stack Frame 정보.
- 스레드가 메서드 하나를 수행하게 되면 Stack Frame 을 하나 생성하여 Stacks 에 Push.

#### Stack Frame
- 스레드가 수행하고 있는 애플리케이션을 메서드 단위로 기록. 
- Local Variable Section, Operand Stack, Frame Data 세 부분으로 구성 됨.

##### Local Variable Section
- 메서드의 파라미터 변수, 로컬 변수를 저장. 
- 0 부터 시작하는 인덱스를 가진 배열로 구성. 
- 0 번에 저장 된 참조를 통해 Heap 에 있는 Class 의 Instance 데이터를 찾아 감. 모든 Local Method 혹은 Instance Method 에 무조건 포함되는 것이  0번 인덱스 값.
- Object 나 String 역시 참조형으로 저장되고 Heap 에서 실제 객체를 찾음.  반면, 기본형은 고정 된 크기가 할당 됨. 
- Heap 을 찾아가 변수 값을 읽어오는 것은 Stack Frame 에서 바로 변수 값을 읽는 것보다 비용이 큼.

##### Operand Stack
- JVM 의 작업공간.
- 프로그램을 수행하며 연산을 위해 사용되는 데이터 및 그 결과를 이곳에 집어넣고 처리.
- 하나의 Instruction 이 연산을 위해 Operand Stack 에 에 값을 밀어 넣고 다음 Instruction 이 이 값을 빼서 사용. 이 값들로 연산이 이루어진다면 그 결과가 다시 Operand Stack 에 저장되어 지정된 곳으로 보내짐.

```java
public class JvmInternal2 {
    public void operandStack() {
        int a, b, c;
        a = 5;
        b = 6;
        c = a + b;
    }
}
```

```
// class version 52.0 (52)
// access flags 0x21
public class io/iamkyu/JvmInternal2 {

  // compiled from: JvmInternal2.java

  // init 부분 중략

  // access flags 0x1
  public operandStack()V
   L0
    LINENUMBER 6 L0
    ICONST_5 // 상수 5를 푸시
    ISTORE 1 // LVS 에 저장. 0번에는 Heap 에 있는 Class Instance
   L1
    LINENUMBER 7 L1
    BIPUSH 6 // 상수 6을 스택에 푸시
    ISTORE 2 // LVS 에 저장
   L2
    LINENUMBER 8 L2
    ILOAD 1 // Operand Stack 에 로드
    ILOAD 2 // Operand Stack 에 로드
    IADD // 연산
    ISTORE 3 // 연산 결과를 LVS 에 저장
   L3
    LINENUMBER 9 L3
    RETURN // Stack Frame 탈출
   L4
    LOCALVARIABLE this Lio/iamkyu/JvmInternal2; L0 L4 0
    LOCALVARIABLE a I L1 L4 1
    LOCALVARIABLE b I L2 L4 2
    LOCALVARIABLE c I L3 L4 3
    MAXSTACK = 2
    MAXLOCALS = 4
}
```

##### Frame Data
- Constant Pool Resolution 정보와 Method 가 정상 또는 비정상 종료시 발생하는 Exception 관련 정보를 저장.
- Resolution 이란 Symbolic Reference 로 표현된 Entry 를 찾아 Direct Reference 로 변경하는 과정을 의미. Class 의 모든 Symbolic Reference 는 Method Area 의 Constant Pool 에 저장 됨.
- Frame Data 에는 자신을 호출한 Stack Frame 의 Instruction Pointer 가 들어 있음. 메서드가 종료되면서 반환 값이 있다면 이 반환 값을 다음 Current Frame 의 Operand Stack 에 푸시하는 작업도 수행.
- 만약, 메서드가 예외를 발생시킨 경우 Frame Data 에서 관리하는 Exception Table 의 Reference 를 통해 catch 절에 해당하는 바이트코드로 점프.

### Native Method Stacks
- 자바 외의 언어로 작성 된 프로그램, API 툴킷 등과의 통합을 위해 Java Native Interface 라는 표준 규약을 제공.
- Native 메서드를 위해 마련 된 스택 공간.
- 벤더사에 따라 Native Method Stacks 를 따로 구현하기도, JVM Stacks 와 통합하여 구현하기도 함.

### Method Area
- 모든 스레드들이 공유하는 메모리 영역. Garbage Collection 의 대상
- 로드 된 타입을 저장하는 논리적 메모리 공간. 여기서 타입은 클래스나 인터페이스를 의미.
- Type Information, Constant Pool, Field Information, Method Information, Class Variables, Reference to class (Class Loader),  Reference to class (class) 의 정보로 구성 됨.

### Heap
- Method Area 와 동일하게 모든 스레드가 공유하는 공간.
- 모든 객체가 저장되는 곳.
- Instance (또는 Object) 와 Array 객체 두 가지 종류만 저장되며 Heap 영역의 메모리 해제는 오로지 GC 를 통해서만 이루어짐

#### Heap 의 구조 (Hotspot JVM 기준)
- 크게 Young, Old Generation 으로 나뉨.
- Young Generation 은 다시 Eden 과 Survivor 영역으로 나뉘는데, Eden 은 Object 가 Heap 최초에 할당되는 장소이고 Eden 영역이 꽉 차면 Object 의 참조 여부를 따져 참조가 되어 있는 객체는 모두 Survivor 영역으로 옮긴 후 Eden 영역을 청소함.
- Young Generation 에서 오래 살아남은 Object 는 Old Generation 으로 이동. 이것을 프로모션이라 함.

### Java Variable Arrangement
- Class Variables => Method Area 의 Class Variable 영역 할당.
- Member Variable => Heap 에 생성 된 Instance 에 할당, 변수 정보는 Method Area 의 Field Information.
- Parameter Variable => Java Virtual Machine Stacks 에 할당, 변수 정보는 Method Area 의 Method Information.
- Local Variable => Parameter Variable 와 동일.
