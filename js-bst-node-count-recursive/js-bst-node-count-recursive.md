재귀를 통한 이진탐색트리의 노드 개수 파악
====


현재 참여하고 있는 스터디 중 하나는 자바스크립트를 통해 데이터구조와 알고리즘을 학습하고 그 과정에서 ES6 문법도 익히는 스터디가 있다. 

>[https://github.com/js-dsa/dsa](https://github.com/js-dsa/dsa)

이번 주의 학습 내용은 이진트리 였는데, 이진트리는 비선형(Non-linear) 자료구조 이기 때문에 탐색이나 삽입, 삭제를 이전에 학습한 선형(linear) 자료구조들과는 많이 다른 방식으로 구현해야 했다. 그 과정에서 재귀(recursive) 함수 응용의 필요가 있었고 스터디 교재에서 노드를 삭제하는 함수에서 재귀를 사용했다.

먼저, ES6 문법이 아직 익숙치는 않지만 나름대로 따라해보며 정의한 Node 클래스는 아래와 같다.

```js
class Node {
    constructor(data, left, right)  {
        this._data  = data;
        this._left = left;
        this._right = right;
    }

    set data(data) {this._data = data;}
    get data() {return this._data;}
    set left(data) {this._left = data;}
    get left() {return this._left;}
    set right(data) {this._right = data;}
    get right() {return this._right;}

    show(){
        return this.data;
    }
}
```

이제 위의 노드 클래스를 사용하여 실제로 이진탐색트리(이하 BST)를 구현해야 하는데 간략하게 일부 함수만 정리한다.

- insert(data) - 트리에 노드(데이터)를 삽입한다.

- remove(node, data) - 트리에서 노드(데이터)를 삭제한다.

- getNodeCount(node) - 노드의 수를 센다.

```js
class BinarySearchTree {
    constructor() {
        this._root = null;
    }

    get root() {
        return this._root;
    }

    set root(node) {
        this._root = node;
    }
}
```


### 삽입

BST에 `insert`가 될때는 먼저 root 노드가 비어있는지를 체크한 후, 루트가 비어 있다면 `insert` 된 노드를 루트로 만들고, 그게 아니라면 계속해서 트리를 탐색하며 삽입할 위치를 정한다. 비교 대상인 노드와 비교하여 새로운 노드가 작은 값이라면 왼쪽으로, 아니라면 오른쪽으로 탐색하여 내려가며 비교한다.

```js
insert(data) {
    let node = new Node(data, null, null);

    if (this.root == null) {
        this.root = node;
    } else {
        let current = this.root;
        while (true) {
            if (data < current.data) {
                if (current.left == null) {
                    current.left = node;
                    break;
                }

                current = current.left;
            } else {
                if (current.right == null) {
                    current.right = node;
                    break;
                }
                current = current.right;
            }
        } // end of while(true)
    }
}
```

### 삭제

노드를 삭제하는 과정은 조금 복잡한데, 고려해야 할 경우의 수가 많기 때문이다.

1. 먼저 삭제하려는 노드를 탐색해야 한다.
2. 삭제하려는 노드가 leaf 노드 (자식이 없는 노드) 라면 
    - 부모 노드의 링크도 끊어줘야 한다.
3. 삭제하려는 노드가 자식 노드가 있다면
    - 1개의 자식노드: 삭제하려는 노드의 부모노드의 자식노드를 이어줘야 한다.
    - 2개의 자식노드: 삭제되는 노드와 가장 비슷한 노드를 후계자로 선택해야 하는데, 왼쪽 서브트리 중 가장 큰 값이나, 오른쪽 서브트리 중 가장 작은 값이 삭제되는 노드와 값이 가장 비슷하다. 아래 소스는 삭제 되는 노드를 기준으로 오른쪽 서브트리를 계속 탐색하여 삭제될 노드의 후계자를 찾는다.


```js
remove(data) {
    this.root = this.removeNode(this.root, data);
}

removeNode(node, data) {
    if (node == null)
        return null;

    if (data == node.data) {
        if (node.left == null && node.right == null) {
            return null;
        }
        if (node.left == null) {
            return node.right;
        }
        if (node.right == null) {
            return node.left;
        }

        let tempNode = this.getSmallest(node.right);
        node.data = tempNode.data;
        node.right = this.removeNode(node.right, tempNode.data);
        return node;
    } else if (data < node.data) {
        node.left = this.removeNode(node.left, data);
        return node;
    } else {
        node.right = this.removeNode(node.right, data);
        return node;
    }
}

getSmallest(node) {
    if (node.left == null) {
        return node;
    } else {
        return this.getSmallest(node.left);
    }
}
```

### 노드 수 카운트

위의 삽입과 삭제는 사실 교재에 ES6 이전의 문법으로 작성된 것을 ES6 문법으로 바꾼 것이고, 연습문제가 BST의 노드 수와 간선의 수를 구하는 함수를 구현하는 것이었다. 먼저, 간선의 수는 항상 노드-1 이기 때문에 노드의 수만 구하면 될 것이다. 단순히 생각하면 변수를 선언해놓고 `insert` 될 때 카운트를 증가시키고 `remove` 될 때 카운트를 감소시켜도 되겠지만 왠지 재귀함수로 구현하는 것이 어울릴 것 같다는 생각이 들었다. 그래서 래퍼런스를 찾아서 구현한 함수는 아래와 같다.

```js
getNodeCount(node) {
    if (node == null) 
    return 0;

    return this.getNodeCount(node.left) + this.getNodeCount(node.right) + 1;
}
```

우리 스터디는 과제 후 코드리뷰 시간을 가지기 때문에, 이 코드를 설명해야 했는데 머리로는 정리가 되지만 말로 표현하기가 쉽지가 않았다. 그래서 그림으로 정리해보니 훨씬 낫다. 사실 나는 재귀함수를 별로 좋아하지는 않는다. 내가 수학을 잘 못하기도 하지만 코드 가독성이 떨어진다고 생각하기 때문이다. 물론 같은 팀원들의 수준이 모두 높다면 무관하겠지만, 일반적인 사람들은 재귀를 이해하기가 힘든 것 같다.

(그림)



## 참고자료

- [자바스크립트 자료구조와 알고리즘, 마이클맥밀런 저, 우정은 역, 한빛미디어, 2014](http://book.naver.com/bookdb/book_detail.nhn?bid=8095174)

- [How to count number of nodes in a Binary Search Tree?](https://encrypt3d.wordpress.com/2010/09/29/how-to-count-number-of-nodes-in-a-binary-search-tree/)

- [이진탐색트리(삽입,삭제,탐색)](http://web.skhu.ac.kr/~cyberci/program/view/view_13.htm) 