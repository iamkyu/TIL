# Java Performance Fundamental

> 김한도 저. 엑셈 출판. 2009.

본 내용은 책 내용에 대한 개인적 이해를 바탕으로 한 요약과 생각이므로 정확한 내용은 반드시 책을 참고하길 권장함.

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


## CH3. Garbage Collection
> Heap Storage for objects is reclaimed by an automatic storage management system (typically garbage collector); objects never explicitly deallocated - Java Virtual Machine Speculation, Section 3.5.3 [JVMS2 1999]

- Java SE8 스펙 기준으로 [2.5.3](https://docs.oracle.com/javase/specs/jvms/se8/html/jvms-2.html#jvms-2.5.3) 절에 위 내용이 있음.
- 메모리 해제에 대한 내용은 이 내용이 전부이고 벤더사는 이 내용을 바탕으로 Garbage Collection 알고리즘을 구현했다고 함.

### GC의 대상
- Garbage 란, Heap 과 Method Area 에 사용되지 않는 오브젝트 (이 두 영역은 모든 스레드가 공유하는 공간이기도 함).
- ‘사용되지 않는다’ 의 기준은 ‘현재’ 를 기준으로 함. 즉, 현재 사용되지 않는 객체가 Garbage.
- 현재 사용여부는 Root Set 과의 관계로 판단. (TODO 여기서 의문인 부분은 GC 에 대한 스펙은 위 문장이 전부라고 했는데 이 기준은 모든 벤더사가 공통되게 적용한건지 궁금.)
- Root Set 에 어떤 식으로든 참조 관계가 있다면 Reachable Object 로 취급.

#### Root Set 구분
아래 세 가지에 해당되지 않는 것은 모두 Garbage 로 판단.
1. Stack 의 참조 정보. Local Variable Section, Operand Stack 에 오브젝트의 참조 정보.
2. Method Area 에 로딩 된 클래스 중, Constant Pool 에 있는 참조 정보.
3. 메모리에 남아 있는 Native Method 로 넘겨진 오브젝트 참조.

### GC 의 목적
- Heap 을 재활용하기 위해 Root Set 에서 참조되지 않는 Object 를 없애 가용 가능한 공간을 만드는 작업.
- GC 는 메모리 압박이 있을때 수행.
- 재활용을 위해 수행 된 메모리 해지는 할당한 그 자리에서 이루어지기 때문에 Garbage 가 빠져 나간 자리는 듬성듬성 함.
- 이런 단편화 현상을 방지하기 위해 Compaction 과 같은 알고리즘이 GC 와 함께 이루어짐.

### GC 의 기본 알고리즘
GC 알고리즘은 크게 Garbage Object 를 찾아내는 부분(Detection)과 제거하는 부분으로 나누어 볼 수 있음.

1. Reference Counting Algorithm
2. Mark-and-Sweep Algorithm
3. Mark-and-Compacting Algorithm
4. Copying Algorithm
5. Generational Algorithm
6. Train Algorithm

#### Reference Counting Algorithm
- 각 객체마다 Reference Count 를 관리함. Count 가 0이 되면 GC.
- TODO 책의 내용으로 유추했을 땐 Stack 의 Local Variable Section 에 Count 가 관리 되는 것 같은데 정확히 어디서 관리하는지를 잘 모르겠음.
- 이 알고리즘의 장점은 비교적 구현이 쉬움.  또한, Reference Count 가 0이 될때마다 GC 가 발생하기 때문에 Pause Time 이 분산됨.
- 반면, 각 Object 마다 Reference Count 를 관리해야 하는 부담과 Memory Leak 의 가능성이 높음. 예컨대, 순환 연결 리스트의 경우 순환 참조를 가짐. 즉 이 리스트에 포함 된 Node 들은 Reference Count 가 0이 될 수 없음.

#### Mark-and-Sweep Algorithm
- Tracing  Algorithm 이라고도 불림. Reference Counting Algorithm 의 단점을 극복하기 위해 등장.
- 알고리즘 이름에서 드러나듯 Mark Phase 와 Sweep Phase 가 나뉘어 짐.
- Mark Phase 에서는 각 객체마다 Reference Count 하는 방식 대신, Root Set 에서 시작하는 참조 관계를 추적하여 Marking 하는 방식 사용. Marking 에도 여러가지 방법이 이 있으나 주로 Object Header 에 Flag 나 별도의 Bitmap Table 을 사용하는 방법을 사용한다고 함.
- Mark Phase 에 이어서 Sweep Phase 돌입. Marking 정보를 활용해 Marking 되지 않은 객체를 지움. Sweep Phase 가 완료되면 모든 객체의 Marking 정보를 초기화.
- 이 알고리즘의 단점은 GC 과정에서 Heap 의 사용이 제한 되어 Suspend 현상 발생. 이유는 Mark 작업의 정확성과 Memory Corruption 을 방지하기 위함. 또한, GC 이후 메모리 단편화로 인해 Free Memory 가 있는 것처럼 보이지만 할당이 불가능한 상황이 될 수 있음. (이건 Reference Counting Algorithm도 동일한 문제가 있지 않나 싶음.)

![mark-and-sweep](https://user-images.githubusercontent.com/13076271/60764466-64b38980-a0c5-11e9-93ae-e683e3d0864b.jpg)
> 출처:  [https://sandeepin.wordpress.com/2011/12/11/mark-and-sweep-garbage-collection-algorithm/](https://sandeepin.wordpress.com/2011/12/11/mark-and-sweep-garbage-collection-algorithm/) 

#### Mark-and-Compaction Algorithm
- Mark-and-Sweep Algorithm 에서 메모리 단편화 문제를 해결하고자 Compaction 과정이 추가 됨. 크게 Mark Phase 와 Compaction Phase 로 구성.

![compaction](https://user-images.githubusercontent.com/13076271/60764668-fa044d00-a0c8-11e9-8229-d99598f4ed19.png)
> 출처: https://www.slideshare.net/novathinker/3-garbage-collection 

- Compaction 은 Live Object 를 연속된 메모리 공간에 적재하는 것을 의미. 보통 하위 Address 로 Compaction 을 수행. Compaction 에는 크게 3가지 방식이 있음.
	1. Arbitrary: 무작위로 정렬
	2. Linear: Reference 의 순서대로 정렬
	3. Sliding: 할당된 순서로 정렬. Heap 은 보통 하위 Address 부터 할당을 시작하기 때문에 할당 순서는 Adress 순서가 되는 경우가 많음
- Linear 방식은 Compaction 을 위해 Reference 의 순서를 따지는 과정에서 오버헤드 발생. 또한, 객체 탐색에 있어서는 어차피 포인터를 기반으로 Random Access 를 수행하기 때문에 참조 객체의 인접함이 큰 장점이 되지 못함.
- Mark - Sweep - Compaction 이 완료되면 새로운 주소로 모든 참조를 변경하는 작업을 수행. Compaction 작업으로 인해 메모리 공간의 효율성을 가지는건 큰 장점이 되지만 모든 참조를 변경하는 작업을 위해 모든 객체를 액세스 하는 등의 오버헤드가 수반 됨. 
- Mark, Compaction Phase 모두 Suspend 현상 발생.

#### Copying Algorithm
- 단편화 문제를 해결하기 위해 제시 된 또다른 방법.
- Heap 을 Active 영역과 Inactive 영역으로 구분. Active 영역에만 객체를 할당 받을 수 있고 Active 영역이 꽉차게 되면 GC 가 수행 됨.
- GC 가 수행되면 모든 프로그램은 Suspend. Live Object 를 Inactive 영역으로 복제함 (Live Object 판단 알고리즘은 아마도 위에서 소개한 Mark 방식). 복제 과정에서 복제 되는 각 객체의 참조 정보도 변경 됨. 복제할때는 한쪽 방향에서부터 차곡차곡 적재하기 때문에 Compaction 수행과 동일한 효과가 있음.
- 복제 과정이 끝나면 Active 영역에 Garbage 객체가, Inactive 영역에는 Live Object 남게 되고 GC 가 완료되는 시점에 Active 영역은 Free Memory 가 두 영역이 서로 바뀜. 이를 Scavenge 라고 함 (Garbage Object 라는 용어로부터 시작하여 작명이 재밌다고 생각 함.). Root Set 의 참조도 복제 된 객체를 향하게 됨.
- Active 와 Inactive 영역은 특정 메모리 번지 구간을 지칭하는 것이 아닌 현재 Allocation 을 하면서 사용하는 공간과 대기 공간의 논리적인 구분임.
- 이 알고리즘은 단편화 방지에는 효과적이지만 전체 Heap 의 절반 정보 밖에 사용하지 못하는 단점과 객체를 복제하는 과정의 오버헤드는 필요악이라고 할 수 있다고 설명.

#### Generational Algorithm
- 대부분의 프로그램에서 생성되는 대다수 객체는 짧은 생애주기를 가지고 일부만이 수명이 길다.
- 이런 경험적 지식을 통해 Copying Algorithm 의 대안으로 등장한 알고리즘.
- Heap 을 Active, Inactive 로 나누는 것이 아니라 Age 별로 몇 개의 Sub Heap 으로 나눔.
- 객체는 최초에 Youngest Generation Sub Heap 에 할당 되고 몇 번의 Mark 과정을 거치면서 Dead 상태가 되지 않으면 Age 가 추가 됨. Age 가 일정 수치를 넘기면 Matured 객체가 되어 다음 Generation 으로 Promotion 됨. (Promotion 은 다음 Sub Heap 으로 복제되는 것을 의미 함.)
- 메모리 단편화, 복제 오버헤드 등 이전 알고리즘의 단점을 상당 부분 극복한 알고리즘. Youngest Generational Sub Heap 에서는 Mark-Sweep 알고리즘, Promotion 과정에서는 Copying 알고리즘과 흡사하게 진행 됨.
- Age, Matured, Promotion 이런 네이밍들이 굉장히 재밌음. Promotion 은 전체적인 문맥에서 조금 어색한 것 같기도 함 :)

#### Train Algorithm
- Incremental Algorithm 이라고도 함.
- Mark-and-Sweep Algorithm 등장 이후 GC 를 수행할 때 프로그램에 Suspend 현상이 나타나는 것은 감수할 수 밖에 없는 일이었음. WAS 와 같이 짧은 트랜잭션을 처리하는 시스템의 경우 불규칙적인 Suspend 현상은 사용자에게 불쾌감을 줄 수 있음.
- 이런 문제를 극복하고자 Heap 을 작은 Memory Block 단위로 나누어 Single Block 단위로 Mark Phase 와 Copy Phase 로 구성된 GC 수행.
- Single Block 단위로 GC 를 수행하는만큼 Heap 의 Suspend 가 GC 수행중인 Memory Block 에만 Suspend 가 발생함.
- Pause Time 을 분산하여 장시간 Suspend 는 피할 수 있는 장점이 있지만 개별 Suspend 시간을 모두 합하면 다른 알고리즘보다 Suspend 시간이 더 많아질 수 있다는 문제점이 있음.

### Hotspot JVM 의 Garbage Collection
Hotspot JVM 의 GC 는 Generational Algorithm 을 기반으로 함. 즉 Heap 을 Generation 으로 나누어 사용.
- Young Generation 에 해당하는 곳은 Eden 영역과 Survivor 영역이 존재.
- Old Generation 에 해당하는 것은 Tenured. 객체가 직접 할당되는 곳이 아닌 Eden 영역에서 성숙된 객체들이 프로모션 되는 곳. 크기에 따라 바로 Allocation 되는 경우도 있다고 함.
- GC 알고리즘을 연구하고 적용하며 얻은 경험적 지식으로 Weak generational 가설을 세우고 Generational Algorithm 에서는 Heap 을 Generation 으로 나누어 구성함. 
- [Oracle - GC Tuning Guide](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/generations.html) 의 Generations 과 [Plumbr – Java Garbage Collection handbook](https://plumbr.io/handbook/garbage-collection-in-java/generational-hypothesis) 에 좀 더 자세히 적혀 있음.

#### Weak generational hypothesis
- 높은 유아사망률 (High Infant Mortality). 새로 생성 된 대부분의 객체가 얼마 되지 않아 Garbage 가 된다. 즉, Young Generation 에 빈번하게 GC가 발생하고 이에 따라 단편화 발생 확률이 높다.
- Young Generation 을 대상으로 하는 GC 를 Minor GC 라고 함.
- 드물긴 해도 Older 객체가 Young 객체를 참조 하는 경우가 있음. 이를 확인하기 위해선 Minor GC 시에도 Older Generation 을 확인해야 함.
- 이를 해결하기 위한 기술이 Card Table 과 Write Barrier.
- Card Table 은 Old Generation 의 메모리를 대표하는 별도의 메모리 구조를 의미. Young 객체를 참조하는 Old 객체가 있다면 Old 객체의 시작 주소에 해당하는 카드에 Dirty 를 표시. Old Generation 메모리 512 Bytes 당 1 Byte 의 카드를 가짐.
- Write Barrier 는 Execution Engine 에 포함 된 코드로 Card Table 에 Dirt 표시 / 해제 하는 작업을 수행하는 코드.
- 이 두 기술을 통해 Old Generation 을 다 확인하지 않고 참조 여부를 확인할 수 있음.
- 이 과정에 대한 설명은 [NAVER D2 - Java Garbage Collection](https://d2.naver.com/helloworld/1329) 에 그림과 함께 정리 되어 있음.

#### Full GC
- Minor GC 의 결과, 충분히 성숙 된 객체는 프로모션이 발생. 이 과정에서 Old Generation 의 메모리가 충분치 않으면 Old Generation 에도 GC 가 발생. 이것을 Full GC 또는 Major GC 라 함.
- 책에서는 Old Generation 에 GC 가 발생하는 것을 Full 또는 Major GC 라고 한다고 되어 있으나, [Plumbr - Minor GC vs Major GC vs Full GC](https://plumbr.io/blog/garbage-collection/minor-gc-vs-major-gc-vs-full-gc) 내용에 따르면  Full GC 는 전체 Heap 을 대상으로, Major GC 는 Old Generation 을 대상으로 하는 것.
- Permanent Area 의 메모리 압박 상황에도 GC 가 발생함. 즉, 너무 많은 수의 Instance 가 로딩되어 Permanent Area 가 부족하게 되면 Heap 에 Free Space 가 많더라도 Full GC 발생.

### Hotspot JVM 의 Garbage Collector
![자바6 까지의 Hotspot JVM Garbage Collector](https://user-images.githubusercontent.com/13076271/61193978-a366c680-a6f9-11e9-87a4-ccfac079a4d0.png)
> 출처: Java Performance Fundamental. 김한도 저. 엑셈 출판. 2009. 118P

- 이 책은 2009년 쓰인 책으로 Java SE 7 릴리즈 전에 쓰임. 하지만 Java 6 Update 14 부터 G1 Collector 가 포함 되어 G1 도 간략하게 소개함.
- Serial Collector 는 가장 기본적인 Collector 로 Default Collector 라고도 불림.
- Serial Collector 등장 후 IT 환경이 급변, 점점 더 큰 Heap 크기를 필요로 하게 됨. Heap 커짐에 따라 Suspend 현상이 두드러졌는데 Application 에는 실시간에 가까운 성능을 요구.
- 이에 따라 Collector 가 크게 두 가지 전략으로 분화되어 발전. (1) 모든 리소스를 투입하여 Garbage Collector 를 빨리 끝내는 전략 (2) Suspend 를 분신시켜 체감 Pause Time 을 줄이는 전략
- Parallel, Parallel Compacting Collection 가 전자에 해당. CMS, Incremental Collector 가 후자에 해당함. Incremental Collector 는 자바 5부터 사용할 수 없었음.

> G1 is planned as the long term replacement for the Concurrent Mark-Sweep Collector (CMS). Comparing G1 with CMS, there are differences that make G1 a better solution. -  [Oracle - Getting Started with the G1 Garbage Collector](https://www.oracle.com/technetwork/tutorials/tutorials-1876574.html)
- 자바 7부터 지원한 G1 (Garbage-First)  Collector 는 Oracle 문서에 따르면 CMS Collector 를 대체하기 위해 등장했다고 함. 
- 자바 11부터 등장한 ZGC 도 있음. 자세히 살펴보지는 못함. [Oracle - An Introduce The Z Garbage Collector (PDF)](http://cr.openjdk.java.net/~pliden/slides/ZGC-FOSDEM-2018.pdf)
- 책을 쓰던 시점에 저자는 Collector 의 발전 추이를 보며 Throughput 과 Low Pause 전략이 더 발전해 나가다 결국 Parallel-Concurrent 로 수렴될 것으로 예상함.

### 자바 버전별 기본 Garbage Collector
- 특정 GC 를 지정하지 않으면 JVM 은 [Ergonomics](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/ergonomics.html#ergonomics) 프로세스를 통해 적절한 Garbage Collector 를 선택함.
- 하드웨어와 OS 를 기준으로 크게 두 분류로 구분. 2 개 이상의 CPU, 2GB 이상의 메모리, 32 Bit 의 Windows 를 제외한 시스템의 경우 Server Class, 반대의 경우 Client Class 분류.
- Java 7&8 - Server: Parallel / Client: Serial
- Java 9 - G1

#### Serial Collector
- 한 개의 스레드로 GC 를 수행.
- Java 8 이하에서 Client Class 의 기본 Garbage Collector.
- Young Generation 에는 Generational Algorithm 을, Old Generation 에는 Mark-and-Compacting Algorithm 을 사용함.
- Young Generation GC
	- Young Generation 의 Survivor 영역은 다시 From 과 To 로 나뉨. 이 구분은 (Hotspot JVM 을 기준으로) 단지 논리적인 구분임. Minor GC 이후에 두 공간의 Flip 하여 사용함.
	- Mark Phase -> Eden 영역과 From 영역에서 Live Mark 된 Object 를 To 영역으로 Copy -> Eden 과 From 영역을  대청소(Scavenge) -> 성숙된(Matured) Object 는 Old Generation 으로 Promotion
	- 성숙된 Object 의  기준은 Object Header 에 기록 된 Age 로 판단. Age 는 Minor GC 때 살아남은 횟수를 의미.
	- 성숙의 기준은 `-XX:MaxTenuringThreshold` 옵션으로 설정할 수 있는데 기본 값이 31, 임의로 설정할 수 있는 값도 최대 31이라고 되어 있음. 하지만 [Oracle - Do Not Set -XX:MaxTenuringThreshold to a Value Greater Than 15](https://support.oracle.com/knowledge/Middleware/1283267_1.html) 문서에 따르면 Java 1.5.0_06 이상부터 최대 값은 15라고 되어 있음. 동작하고 있는 JVM 에서 `$ java -XX:+PrintFlagsFinal -version | grep MaxTenuringThreshold` 커맨드를 통해 해당 옵션에 지정된 값을 확인할 수 있음.
- Old Generation GC
	- Old Generation 은 GC 가 자주 발생하진 않지만 발생하면 Minor GC 보다 Suspend 시간이 길어짐.
	- Young Generation 보다 크기도 하고 수행방식에 차이가 있기 때문.
	- 알고리즘 자체도 Generational 에 비해 Garbage 를 Sweep - Compaction 하는 시간을 많이 필요로 함.
	- 또한, Old Generation 에 GC 가 수행되는 이유는 Promotion 때문인데 Minor GC 와중에 Promotion 을 위한 메모리 공간이 부족해 Major GC 가 연쇄적으로 수행되기 때문임.

#### Incremental Collector
- Low Pause Goal 을 충족하기 위한 최초의 Collector.
- Young Generation 에는 Generational Algorithm 을, Old Generation 에는 Train Algorithm 을 사용함.
- Suspend 시간을 줄여준다는 장점에도 불구하고 자바 6에서 공식적으로 사라짐. 저자는 다음과 같은 단점때문이 아닌가 추측함.
	- 각 Memory Block 을 가득차게 쓰는 것이 힘들어 Old Generation 이 커질수록 Memory Block 의 단편화 현상이 심화됨.
	- Minor GC 를 수행할때 Old Generation 의 GC 대상 Single Memory Block 을 선택하는 작업의 오버헤드.
	- Remember Set 의 Storage 오버헤드.
- 반면, Train Algorithm 아이디어 자체는 좋은 평가를 받아 G1 Collector 에서 해당 알고리즘을 발전시켜 사용.

#### Parallel Collector
- 멀티스레드로 GC 를 수행. 하지만 Old Generation 의 GC 는 Serial Collector 와 동일하고 Young Generation 에만 국한 됨.
- Parallel Collector 의 Parallel Copy Algorithm 은 Generational Algorithm 과 차이가 없지만 Young Generation 영역의 Live Object 의 Copy 과정을 여러 스레드가 동시에 수행.
- 단, 메모리 공간을 두 Thread 혹시 Process 가 접근함으로 발생하는 Corruption 을 회피하기 위해 동기화 작업을 수반하면 Promotion 성능이 떨어짐.
- 이를 극복하기 위해 PLAB (Parallel Local Allocation Buffer) 를 마련. GC Thread 가 Promotion 시 베타적으로 사용하기 위해 스레드 마다 Old Generation 의 일정 부분을 할당해 놓는 것.
- 하지만 이 방법도 Old Generation 에 단편화 문제가 발생. 많은 수의 스레드가 자신의 Buffer 를 할당 받은 채 사용하지 않거나, 어쩔 수 없이 발생하는 Buffer 내 자투리 공간이 Heap 단편화의 원인이 도리 수 있음. 이 경우 GC Thread 를 감소시키거나 Old Generation 의 Size 를 늘리는 방법으로 문제를 회피할 수 있음.

#### CMS(Concurrent Mark-Sweep) Collector
- 비교적 자원이 여유 있는 상태에서 GC 의 Pause Time 을 줄이고자 하는 목적에 가장 부합.
- Parallel Collector 와 동일하게 Young Generation 에는 Parallel Copy Algorithm 을, Old Generation 에는 Concurrent Mark-Sweep Algorithm 을 사용.
- Concurrent Mark-Sweep Algorithm 은 다음 단계로 구성
	- 1. Initial Mark 단계로 싱글스레드가 애플리케이션에서 직접 참조 되는 Live Object 를 구별. Heap 은 Suspend 상태가 되지만 Root Set 에서 직접 참조 되는 Object 만을 대상으로 하기 때문에 시간은 최소화 됨.
	- 2. Concurrent Mark 단계는 싱글스레드가 1단계에서 선별된 Object 를 대상으로 참조 Object 를 추적하여 Live 여부 구별. GC 스레드 외 Working 스레드들은 애플리케이션을 수행할 수 있음.
	- 3. Remark 단계는 유일한 Parallel 단계로 모든 스레드가 GC 에 동원됨. 이로 인해 애플리케이션은 잠시 수행이 중지 됨. 이 단계에서 이미 Marking 된 Object 를 다시 추적하여 Live 여부 확정. 
	- 4. Concurrent Sweep 단계도 애플리케이션과 GC 의 동시작업(Concurrent)이 가능. Remark 작업을 통해 최종적인 Dead Object 제거 작업 수행. 하지만 Compacting  작업은 수행하지 않음.
- Compacting 작업을 위해서는 Heap 의 Suspend 를 전제로 해야 하는데 CMS Collector 는 이를 수행하지 않음으로써 GC 동안에도 애플리케이션의 수행을 보장. 그러나 반복 된 Sweep 은 연속된 Free Space 가 감소되는 부작용을 가지고 옴.
- 이를 해결하기 위해 FreeList 를 사용하여 프로모션 되는 Object 사이즈를 계속 통계화하여 미래 요구량을 추정하고, Object 프로모션 되면 크기가 비슷한 Free Space 를 탐색하여 할당. 반면, 이 방법은 Young Generation 의 부담을 가중시킴. FreeList 를 통해 할당이 적합한 공간을 탐색하는 과정이 추가 되기 때문. 이로 인해 프로모션 되어야 할 Object 들이 Eden 또는 Survivor 영역에서 체류시간이 길어지는 결과를 낳지만 Compacting 이 워낙 고비용 작업이기 때문에 손익 비교가 필요함. 예컨대, 프로모션이 빈번하지 않다면 이를 통해 얻는 성능상 이득이 큼. 
- CMS Collector 는 Floating Garbage 문제도 발생 할 수 있음. 때문에 Collection 에서 Schedule 을 고려.
- 참고로 2019년 8월에 [OpenJDK JEP](https://openjdk.java.net/jeps/8229049) 에는 CMS Collector 를 제거하는 draft 가 제안됨

#### Parallel Compaction Collector
- Parallel Collector 에서 Old Generation 에 새로운 알고리즘을 추가한 콜렉터.
- Young Generation 에서는 Parallel Copy Algorithm 을, Old Generation 에서는 Parallel Copy Algorithm 을 추가하여 사용.
- 다음 단계로 GC  수행.
	- 1. Mark Phase. Parallel 로 작업이 수행. Old Generation 을 Region 이라는 논리적이고 2Kbytes 정도의 청크 단위로 나누고 Collection 스레드들이 각 Region 별로 Live Object 를 마킹.
	- 2. Summary Phase 는 단일 스레드가 1단계의 결과인 Region 마다의 통계 정보를 바탕으로 각 Region 의 Density 평가. 이는 각 Region 의 Reachable Object 의 밀도를 나타냄. Density 를 바탕으로 Reachable Object 가 대부분을 차지하는 Region 이 어디까지인지를 구분하여 Dense Prefix 를 설정. Prefix 왼편의 있는 Region 은 GC 대상에서 제외됨.
	- 3. Compaction Phase 는 Heap 을 Suspend 상태로 만들고 모든 스레드가 각 Region 을 Compacting 하는 작업 수행. Garbage Object 를 Sweep 하고 Reachable Object 를 왼편으로 몰아 넣음.

#### Garbage First (G1) Collector
이 책은 G1 이 갓 등장한 시점에 쓰였기 때문에 다음 자료를 추가로 참고함.
- 자바성능튜닝. 스캇 오크스 저. 최가인 역. 비제이퍼블릭 출판. 2016.
- 자바최적화. 벤저민 J. 에번스 외 2명 저. 이일웅 역. 한빛미디어. 2019.
- [Oracle - Getting Started with the G1 Garbage Collector](https://www.oracle.com/technetwork/tutorials/tutorials-1876574.html)

기존 Generation 기반의 Collector 들과는 다른 구조를 지님. 장기적으로는 CMS Collector 를 대체하기 위해 등장.

> G1 is planned as the long term replacement for the Concurrent Mark-Sweep Collector (CMS). Comparing G1 with CMS, there are differences that make G1 a better solution. One difference is that G1 is a compacting collector. G1 compacts sufficiently to completely avoid the use of fine-grained free lists for allocation, and instead relies on regions. This considerably simplifies parts of the collector, and mostly eliminates potential fragmentation issues. Also, G1 offers more predictable garbage collection pauses than the CMS collector, and allows users to specify desired pause targets.
> - [Oracle Tutorials: Getting Started with the G1 Garbage Collector](https://www.oracle.com/technetwork/tutorials/tutorials-1876574.html)

- Generation 기반의 Young, Old 물리적 구분 방식은 Weak generational hypothesis 에 따라 Young Generation 에 집중함으로써 효율을 높일 수 있었음.
- 반면, CMS Collector 등에서 나타난 것 처럼 Old Generation 의 파편화, Freelist 사용으로 인한 문제, Suspend Time 의 길어짐 등 결국 Stop-The-Word 방식의 Compaction 으로 회귀할 수 밖에 없는 상황이 됨.
- 그래서 G1 은 물리적인 Generation 의 구분을 없애고 전체 Heap 을 1Mb 단위의 Region 으로 재편. (Heap 이 클수록 크기가 커짐. 최소 1Mb - 최대 32Mb)
- Garbage 로만 꽉 차 있는 Region 부터 Collection 을 시작한다고 해서 Garbage First Collector 라는 이름이 붙여짐. 
- Garbage Region 은 발견되자 마자 즉각적으로 Collection 이 이루어짐. Garbage Object 가 대부분인 Region 의 경우 Live Object 는 Old Region 에서 다른 Old Region 으로 Compaction  이 이루어짐.
- 이전 Collector 들과 달리 Young 과 Old 는 개념적인 구분이고 연속되어 있지 않은데, Object 가 새로 할당되는 Region 의 집합을 Young, Promotion 되는 Region 의 집합을 Old 라고 칭함.
- Minor GC 가 발생하면 Young Generation 의 Region 을 대상으로 Reachable Object  를 찾아내 Age 가 되지 않는 Object 는 Survivor Region 으로, Promotion 대상은 Old Generation 으로 Copy. 그 후 기존의 Young Generation Region 은 Garbage 로 간주하여 Region 단위로 할당을 해지. 이렇게 Young Generation 의 Collection 이 끝나면 바로 Old Generation 의 GC 가 시작됨.
- 철저하게 Region 단위로 GC 가 발생하기 때문에 이로 인한 Suspend 현상도 Region 을 사용하는 Thread 에 국한 됨.
- G1 이 Region 내 Reference 를 관리하는 방법은 Remember Set 을 이용. 전체 Heap 의 5% 미만 정도의 공간을 각 Region 참조 정보 (Region 내부 정보가 아닌) 를 저장하는 공간으로 할당. 따라서 내부를 바라보는 레퍼런스를 찾으려고 전체 힙을 뒤질 필요가 없음.
