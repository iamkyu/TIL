### Commit Rules

> 가능한 커밋마다 의미를 부여하고 도메인에 종속 (domain) 인 경우 scope 추가
>
> feat: 기능 추가  
>
> fix: 오류수정  
>
> docs: 문서파일 수정  
>
> perf: 성능개선코드  
>
> refactor: 리팩토링  
>
> test: 누락된 테스트코드  
>
> chore: 잡다변경 ( 포멧팅, 설정변경 등)  

```bash
# show 도메인에 상영정보등록 기능을 구현했을때의 커밋메시지 예시

feat(show): 상영정보등록
# (~blank~)
 - 상영 정보를 등록한다.
 - 상영 스케쥴을 등록한다.
# (~blank~)
closes #23
```