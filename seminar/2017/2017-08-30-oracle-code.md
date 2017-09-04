# Oracle Code 2017 Seoul

- 행사소개 [https://developer.oracle.com/code/seoul](https://developer.oracle.com/code/seoul)
- 2017년 8월 30일 (수) 09:00~18:00
- 콘레드호텔

# Vagrant, Terraform, Ansible을 활용한 클라우드 인프라 관리법 / 김태완님

## TL;DR

- 클라우드의 (하이퍼 바이저 위의)모든 자원들은 통제 가능하다.
- 애플리케이션과 같이 인프라스트럭쳐를 버전관리, 단위 테스트 지속적 통합/인도, 자동화 등을 통해 형상을 관리하고 안정적인 상태로 유지할 수 있는 도구들이 있다.
  - 대표적인 도구로 Terraform / Ansible, Chef, Puppet / Serverspec, Testinfra 등이 있다.

![image-cloud-resources-control](https://lh3.googleusercontent.com/j6b9BYqScqdgZ7HrJ_HZDmnst8SUAS4tYcTNucv57AQQMaBJNHoytMtjhBVgkc1l9LkJCTnF4jFhZ6ok5PnPVEi4kPnPz2zdlPOPEgwS1a_sob_ApijMBNvSzV_jEj0E5qt57BNLn1m0khjM0BWWYEMqf7iL0IpeEYNiQWnW_oS7QHfvDa2NnIK38qhQM6iNOLaEMwNf65v0P-E5ule6qxgEuXJEQHAe0ItPEGbe9WLp7RF-kzKP2pCfu8NYRP39YA89GuloolYKiy2EsuS9SN8fZMk-eAcb66Kv_KDgBivsxYpoZArK_omfNslX_0DKT41st0r5ILh1hiVhCq4Vl4TTW6LYosByWlPafKuZ0UYZcwBpXTm2b2iHRlkw9fSJsU1QqGSeuLzvibY5JsvdG79SduwNsrojCKYVcEB_SrJFXtLFRBrt5ZBe0UoTTukqj9uuKNtOr6G1zmALYN17kND1zzExNGCbhb4TUMh0ykhEbruViOwnNNf54Sqkx10i8Sx8QqVf0VkrgKQU1Q5vpbYDHP2gSRQ9GVMnVez2O_0j8z5iYkD6qA-4rSrnhczB1bRyW0tGhiY=s928-w928-h425-no)



## 통제 가능한(Controllable) 자원

> 고객: 오늘 시스템이 왜 이렇게 느려요?
>
> 개발자: 비가 와서 그런 것 같습니다.

이런 유머(?)가 있을 만큼 클라우드 이전의 I.T 시대 에서는 통제 불가능한 영역이 많았음. 주로 통제 가능한 영역은 애플리케이션.

버전관리, 빌드도구, 라이브러리 관리, 단위 테스트 지속적 통합/인도 등을 통해 형상을 관리하고 자원을 안정적인 상태로 유지.

![image-applicaiton-control](https://lh3.googleusercontent.com/R-BiwS1AAQJYJNMQcVRl3Lte6ZBkTI_bu6LGeR8Pmk9mpET0mOVLUUjHl0bsTjPETK0jXMdZTu5o6zInQPgHtKpNPsKuI-l4ngJW6xUUoCQcbLI6mJ_KdYHv1ato99J3Vs3T5cd0YPr4bGOYGNdBN6QX3Sm81G8ulzVO-VZmIpwv7JIzDz3lhtOeW-pJusi8Bmtni8K_mjfg7Ogy3Wey5uw-kFJV23hWyzQSV1wqoiIauAFsBzrlHXNJaRbt14Rj1BDWE2isFomyj_r5UKAt44IggqMCKdxw-zjqTyDvbHzpovrd0Dt_JYmBOwRqqD_h2yB9CYqeXLV1eiJ_PNOkcxy-hqekdMbBn-qpAb-KRPTy6AB1dcpdwGWO6V5woQKvAKEf1vzEIaY4_5dqZfoZN_c66epzvSOSEdZQ0Qft3RM29vWJh5-VTtPVsd7DZzajt1YiskznuDYh3BWIMKzo8_YZ-qA7DFH1gOlx_-mlnggiGCCpuUPD_i-msTC9MKOKLt6h1w2XBcNa7tV8pqFVcvH5BKNHsxZcuS2c1fxGAUTDrvWFqY2ZzhK51MqjSKwJfI3wLjWQtwg=s939-w939-h431-no)

> 클라우드 시대에서 애플리케이션만이 소프트웨어가 아니라 그 애플리케이션이 동작하기 위해 필요한 클라우드 자원들이 모두 포함 되어야 한다. 그리고 이 모든 자원들은 통제 가능해야 한다.



![image-cloud-infrastructure-control](https://lh3.googleusercontent.com/pU9HlyuZCn8iEUhw2OlPiNtjDuGXY55vwKg0r7tkLfHiDCnZzkracYPvx0RwQDXC0fkuMIKPhSGr0pQMiOYETd-1gU5hPLEmAz2sUVc0M9IrS9f99jY4-TvYnFFhHDUDBSgmpVQu5y8-t9k3-QOyXjdLnuLp0kBQvXRkygimbiWLG1ZWxMcmcGsyfnxEtVo50buj7N6MfIYUdILfPQmkHNbnWyWW-8CfEwp5WTdauP2hZvENr6jWO31Z_WoGqWlGKCTOFHhEOtwVpIpprEriC1ev4Bt7h7nKn2bCZK9KNnS8gDqzfzJsrcvqrgnaTlxkiz45Te6CKxbrCxA5AI0ljwSSWy_PQxUl1VrY_l6W4FIpv3htx-9vXpKbpdtJMngqHJWMWcz9lrCSkm3HN5I__I6kzfMS6ItkBB9wxZi9vZShpyDiGerMhG-gNY6fz3fS2GyRusPGxZCnXROPNlnsWjo7OB5b9ncr5zu_TGSnr7hcxdlyBKEaD_JzzZntmcVN4sfCCZwn6K0RIB2QNqVwQMeO-s7APW04OihD_iUokJZWxTfljgnNjCo30Tf5fOp5MTbmxSJyp0s=s927-w927-h416-no)

클라우드 자원을 통제하기 위한 도구도 애플리케이션을 통제 하기 위한 도구들과 거의 같음. 버전관리, 빌드도구, 라이브러리 관리, 단위 테스트 지속적 통합/인도 등...

이제는 인프라가 하드웨어적으로 딱딱한 환경이 아니라 소프트웨어적으로 접근 가능한 영역이 되었기 때문에 자동화 할 수 있고, 검증하는 것이 가능.



## Provisioning & Infrastructure as Code

> Provisioning: 사용자의 요구에 맞게 시스템 자원을 할당, 배치 배포해 두었다가 필요 시 즉시 사용할 수 있는 상태로 미리 준비해두는 것.

프로비저닝 과거에는 일종의 형상 관리, 배포와 같은 이미지를 가지고 있었으나 클라우드 시대에서는 개념이 확대 됨.

1. Infrastructure Provisioning
   - 이제 인프라는 OS, 하드웨어, 네트워크만으로 국한되는 것이 아니라 클라우드에서 사용할 수 있는 모든 자원을 사용할 수 있도록 할당 받는 행위
2. Configuration Management
   - 할당 받은 클라우드 자원의 형상 관리.

클라우드 시대의 인프라는 형체가 없음. 영구적인 보관소가 아님. 따라서 하드웨어와 바이너리로 구성되 있는 인프라의 형상을 텍스트로 버전 관리 해야 함. Infrastructue as Code.



### 대표적 Provisioning 도구: Terraform by HashiCorp

- 다양한 벤더 지원
- 오픈 소스 생태계
- 적용 전 변경 사항 미리보기 (Plan)
- 리소스간 의존성을 그래프로 확인
- 재 사용성이 높다.

```shell
// AWS EC2 를 생성하는 테라폼 코드 예제

provider "aws" {
    access_key = "PUT-YOUR-ACCESS-KEY"
    secret_key = "PUT-YOUR-SECRET-KEY"
    region = "PUT-YOUR-REGION"
}

resource "aws_instance" "example" {
    ami = "ami-8663bae8"
    instance_type = "t2.micro" 
}
```

```shell
$ terraform apply
```

웹 브라우저 상에서 여러 페이지에 거쳐 마우스로 선택하고 키보드로 입력해서 아마존 ec2 인스턴스 생성 과정을 위 코드로 대체할 수 있으며 재사용 가능 함.



### 대표적 Configuration Management 도구:  Ansible, Chef, Puppet

여러 대의 서버에 소프트웨어를 설치하고 환경 변수를 설정하고 사용자를 세팅하는 과정을 자동화

![image-ansible-mgmt](https://lh3.googleusercontent.com/ojx2uXgbLKel-wFp_2zmiea0QpztjLz7YrV5RpSsrSDv0GZrRWSVTt9nhY5-jvTkMx15qHAm2z5fgNpoW_L0degDORF8LIyATPcOA-deYzcQbGjoHO_kcLYwQ7ZwZfsxWwK5Ix0LR8RL69IMM8BPaOUW5NcK7wYrSP6jWOBo6cWCa7Mw3P_w-bTqpuBJgZm1mk8Jz0NditvJhiXTvOova5EmFThVQn6yjWJgP-A4bepDwXYP8j7gvpNVt4L9m-nmt0GiK8g6_yxzGEv2rHGT30sFgMeAcIHwvopHgE4ow89v04MpFOFKipJTNpjPtIxtrf_lxPp9t5N5RCYYIHU0ZRViPC54cTtRUpwxI6bmasF0dHyT__o2QiKkUxCZzZ4qGlvc0GYgOFZiQJkvsdevOH0AbK1lWOczaBp-zXFkLQx1QkJ5Izzdx-68p2nNZK9K8JtUS48GLYxfF6oxSonfSt5_iVka2lnaRORWUKQhx9XPYjzoNAPFc6ZC8I3XJ4lNlliL3GxBJ0S8PWWwPdgw7Q3DeAzMl7ZT7v34HWI485BSA9jkFuvRk8GKEDyY7Ok21e_8H2gpOkg=s960-w960-h600-no)



## Infrastructure Validation

자동으로 구성 된 인프라를 어떻게 검증할 것인가? 하나 하나의 서버에 접속해서 계정 만들어졌나, 웹서버 올라갔나 확인할 수 는 없음.



### 대표적 인프라 테스트 도구:  Serverspec, Testinfra

```ruby
// serverspec을 통해 인프라 테스트 예시
describe command('java -version') do
  its(:stderr) { should match /java version \"1.8/ }
  it { should return_exit_status 0 }
end
 
 
describe port(8080) do
  it { should be_listening }
end
```



# 링크

- [Oracle Cloud 블로그: 발표자료 및 데모](http://www.oracloud.kr/post/oracle_code_provisioning/#testinfra)
- [Youtube 발표영상 2:52:38 부터 (초반 5분 정도 사운드 겹침)](https://youtu.be/ES9t1z3NCOA)
