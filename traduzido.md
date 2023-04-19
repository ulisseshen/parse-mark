---
title: Entendendo restrições
description: O modelo do Flutter para restrições, dimensionamento, posicionamento de widgets e como eles interagem.
toc: false
js:
  - defer: true
    url: https://dartpad.dev/inject_embed.dart.js
---
{{site.alert.note}}
  Para entender melhor como o Flutter implementa as restrições de layout,
  assista ao seguinte vídeo de 5 minutos:
  Decodificando Flutter: Altura e largura ilimitadas
{{site.alert.end}}
---
Quando alguém aprendendo Flutter pergunta por que um widget
com `width:100` não tem 100 pixels de largura,
a resposta padrão é dizer que ele deve colocar o widget
dentro de um `Center`, certo?
---
**Não faça isso.**
---
Se você fizer isso, eles voltarão várias vezes,
perguntando por que algum `FittedBox` não está funcionando,
por que aquela `Column` está transbordando ou o que
`IntrinsicWidth` deveria estar fazendo.
---
Em vez disso, primeiro diga que o layout do Flutter é muito diferente
do layout HTML (provavelmente de onde eles estão vindo),
e então faça-os memorizar a seguinte regra:
---
Restrições descem. Tamanhos sobem. O pai define a posição.
---
O layout do Flutter não pode ser realmente entendido sem conhecer
esta regra, então os desenvolvedores de Flutter devem aprendê-la no início.
---
Em mais detalhes:
---
* Um widget recebe suas próprias **restrições** de seu **pai**.
  Uma _restrição_ é apenas um conjunto de 4 doubles:
  uma largura mínima e máxima e uma altura mínima e máxima.
* Em seguida, o widget percorre sua própria lista de **filhos**.
  Um por um, o widget diz a seus filhos quais são suas
  **restrições** (que podem ser diferentes para cada filho),
  e então pergunta a cada filho qual tamanho ele deseja ter.
* Depois, o widget posiciona seus **filhos**
  (horizontalmente no eixo `x` e verticalmente no eixo `y`),
  um por um.
* E, finalmente, o widget informa ao seu pai sobre seu próprio **tamanho**
  (dentro das restrições originais, é claro).
---
Por exemplo, se um widget composto contiver uma coluna
com algum preenchimento e desejar organizar seus dois filhos
da seguinte maneira:
---
A negociação acontece algo assim:
---
**Widget**: "Ei, pai, quais são as minhas restrições?"
---
**Pai**: "Você deve ter de `80` a `300` pixels de largura
   e de `30` a `85` de altura."
---
**Widget**: "Hmmm, como eu quero ter `5` pixels de preenchimento (padding),
   então meus filhos podem ter no máximo `290` pixels de largura
   e `75` pixels de altura."
---
**Widget**: "Ei, primeiro filho, você deve ter de `0` a `290`
   pixels de largura e de `0` a `75` de altura."
---
**Primeiro filho**: "Ok, então eu quero ter `290` pixels de largura
   e `20` pixels de altura."
---
**Widget**: "Hmmm, já que quero colocar meu segundo filho abaixo do
   primeiro, isso deixa apenas `55` pixels de altura para
   o meu segundo filho."
---
**Widget**: "Ei, segundo filho, você deve ter de `0` a `290` de largura,
   e de `0` a `55` de altura."
---
**Segundo filho**: "OK, eu quero ter `140` pixels de largura,
   e `30` pixels de altura."
---
**Widget**: "Muito bem. Meu primeiro filho tem posição `x: 5` e `y: 5`,
   e meu segundo filho tem `x: 80` e `y: 25`."
---
**Widget**: "Ei, pai, decidi que meu tamanho será de `300`
   pixels de largura e `60` pixels de altura."
---
## Limitações
---
Como resultado da regra de layout mencionada acima,
o mecanismo de layout do Flutter possui algumas limitações importantes:
---
* Um widget pode decidir seu próprio tamanho apenas dentro das
  restrições dadas a ele por seu pai.
  Isso significa que um widget geralmente **não pode ter qualquer
  tamanho que desejar**.
---
* Um widget **não pode saber e não decide sua própria posição
  na tela**, já que é o pai do widget que decide
  a posição do widget.
---
* Como o tamanho e a posição do pai, por sua vez,
  também dependem de seu próprio pai, é impossível
  definir com precisão o tamanho e a posição de qualquer widget
  sem levar em consideração a árvore como um todo.
---
* Se um filho quer um tamanho diferente do de seu pai e
  o pai não tem informações suficientes para alinhá-lo,
  então o tamanho do filho pode ser ignorado.
  **Seja específico ao definir o alinhamento.**
---
## Exemplos
---
Para uma experiência interativa, use o seguinte DartPad.
Use a barra de rolagem horizontal numerada para alternar entre
29 exemplos diferentes.
---
Se preferir, você pode pegar o código de
[este repositório GitHub][].
---
Os exemplos são explicados nas seções a seguir.
---
### Exemplo 1
---
A tela é o pai do `Container`, e faz com que o `Container`
tenha exatamente o mesmo tamanho da tela.
---
Então o `Container` preenche a tela e a pinta de vermelho.
---
### Exemplo 2
---
O `Container` vermelho quer ter 100 × 100,
mas não pode, porque a tela o obriga a ter
exatamente o mesmo tamanho da tela.
---
Então o `Container` preenche a tela.
---
### Exemplo 3
---
A tela obriga o `Center` a ter exatamente o mesmo tamanho
que a tela, então o `Center` preenche a tela.
---
O `Center` diz ao `Container` que ele pode ter qualquer tamanho que
quiser, mas não maior que a tela. Agora o `Container`
pode realmente ser 100 × 100.
---
Exemplo 4
---
Este exemplo é diferente do anterior porque usa `Align` em vez de `Center`.
---
`Align` também diz ao `Container` que ele pode ter qualquer tamanho que desejar, mas se houver espaço vazio, ele não centralizará o `Container`. Em vez disso, alinha o container ao canto inferior direito do espaço disponível.
---
Exemplo 5
---
A tela força o `Center` a ter exatamente o mesmo tamanho que a tela, então o `Center` preenche a tela.
---
O `Center` diz ao `Container` que ele pode ter qualquer tamanho que desejar, mas não maior que a tela. O `Container` deseja ter tamanho infinito, mas como não pode ser maior que a tela, apenas preenche a tela.
---
Exemplo 6
---
A tela força o `Center` a ter exatamente o mesmo tamanho que a tela, então o `Center` preenche a tela.
---
O `Center` diz ao `Container` que ele pode ter qualquer tamanho que desejar, mas não maior que a tela. Como o `Container` não tem filho e não tem tamanho fixo, decide que quer ser o maior possível, então preenche a tela inteira.
---
Mas por que o `Container` decide isso?
Simplesmente porque é uma decisão de design de quem
criou o widget `Container`. Ele poderia ter sido
criado de forma diferente e você precisa ler a
[documentação do `Container`][] para entender como ele
se comporta dependendo das circunstâncias.
---
Exemplo 7
---
A tela força o `Center` a ter exatamente o mesmo tamanho que a tela, então o `Center` preenche a tela.
---
O `Center` diz ao `Container` vermelho que ele pode ter qualquer tamanho que desejar, mas não maior que a tela. Como o `Container` vermelho não tem tamanho, mas tem um filho, ele decide que quer ser do mesmo tamanho que seu filho.
---
O `Container` vermelho diz ao seu filho que ele pode ter qualquer tamanho que desejar, mas não maior que a tela.
---
O filho é um `Container` verde que deseja ter 30 × 30. Como o `Container` vermelho ajusta seu tamanho ao tamanho de seu filho, também é 30 × 30. A cor vermelha não é visível porque o `Container` verde cobre completamente o `Container` vermelho.
---
Exemplo 8
---
O `Container` vermelho ajusta seu tamanho ao tamanho de seus filhos, mas leva em consideração seu próprio preenchimento (padding). Então também é 30 × 30 mais o padding. A cor vermelha é visível por causa do pedding, e o `Container` verde tem o mesmo tamanho que no exemplo anterior.
---
### Exemplo 9
---
Você pode imaginar que o `Container` deve ter entre 70 e 150 pixels, mas estaria errado. O `ConstrainedBox` impõe apenas restrições **adicionais** àquelas que recebe de seu pai.
---
Aqui, a tela força o `ConstrainedBox` a ter exatamente o mesmo tamanho que a tela, então ele diz ao seu filho `Container` para também assumir o tamanho da tela, ignorando seu parâmetro `constraints`.
---
### Exemplo 10
---
Agora, `Center` permite que `ConstrainedBox` tenha qualquer tamanho até o tamanho da tela. O `ConstrainedBox` impõe restrições **adicionais** de seu parâmetro `constraints` ao seu filho.
---
O Container deve ter entre 70 e 150 pixels.
Ele quer ter 10 pixels,
então acaba tendo 70 (o mínimo).
---
### Exemplo 11
---
`Center` permite que `ConstrainedBox` tenha qualquer tamanho até o tamanho da tela. O `ConstrainedBox` impõe restrições **adicionais** de seu parâmetro `constraints` ao seu filho.
---
O `Container` deve ter entre 70 e 150 pixels.
Ele quer ter 1000 pixels,
então acaba tendo 150 (o máximo).
---
### Exemplo 12
---
`Center` permite que `ConstrainedBox` tenha qualquer tamanho
até o tamanho da tela. O `ConstrainedBox` impõe restrições
**adicionais** de seu parâmetro `constraints` ao seu filho.
---
O `Container` deve ter entre 70 e 150 pixels.
Ele quer ter 100 pixels, e é esse o tamanho que tem,
já que está entre 70 e 150.
---
### Exemplo 13
---
A tela força o `UnconstrainedBox` a ter exatamente o mesmo tamanho que a tela. No entanto, o `UnconstrainedBox` permite que seu filho `Container` tenha qualquer tamanho que desejar.
---
### Exemplo 14
---
A tela força o `UnconstrainedBox` a ter exatamente o mesmo tamanho
que a tela, e `UnconstrainedBox` permite que seu filho
`Container` tenha qualquer tamanho que desejar.
---
Infelizmente, neste caso, o `Container` tem 4000 pixels de
largura e é muito grande para caber no `UnconstrainedBox`,
então o `UnconstrainedBox` exibe o tão temido
"aviso de estouro".
---
### Exemplo 15
---
A tela força o `OverflowBox` a ter exatamente o mesmo tamanho
que a tela, e o `OverflowBox` permite que seu filho `Container`
tenha qualquer tamanho que desejar.
---
O `OverflowBox` é semelhante ao `UnconstrainedBox`;
a diferença é que ele não exibirá nenhum aviso se o
filho não couber no espaço.
---
Neste caso, o `Container` tem 4000 pixels de largura
e é muito grande para caber no `OverflowBox`, mas o
`OverflowBox` simplesmente mostra o máximo
que pode, sem avisos.
---
### Exemplo 16
---
Isso não renderizará nada, e você verá um erro no console.
---
O `UnconstrainedBox` permite que seu filho tenha qualquer
tamanho que desejar, no entanto, seu filho é um `Container` com tamanho infinito.
---
O Flutter não pode renderizar tamanhos infinitos, então ele lança um erro com a seguinte mensagem: `BoxConstraints forces an infinite width.`
---
### Exemplo 17
---
Aqui você não terá mais erros, porque quando o `LimitedBox` recebe um tamanho infinito do `UnconstrainedBox`, ele passa uma largura máxima de 100 para o seu filho.
---
Se você trocar o `UnconstrainedBox` por um widget `Center`, o `LimitedBox` não aplicará mais seu limite (já que seu limite é aplicado apenas quando recebe restrições infinitas) e a largura do `Container` é permitida ultrapassar 100.
---
Isso explica a diferença entre um `LimitedBox` e um `ConstrainedBox`.
---
### Exemplo 18
---
A tela força o `FittedBox` a ter exatamente o mesmo tamanho que a tela. O `Text` tem uma largura natural (também chamada de largura intrínseca) que depende da quantidade de texto, do tamanho da fonte, etc.
---
O `FittedBox` permite que o `Text` tenha qualquer tamanho que desejar, mas após o `Text` informar seu tamanho ao `FittedBox`, o `FittedBox` dimensiona o texto até preencher toda a largura disponível.
---
### Exemplo 19
---
Mas o que acontece se você colocar o `FittedBox` dentro de um widget `Center`? O `Center` permite que o `FittedBox` tenha qualquer tamanho que desejar, até o tamanho da tela.
---
O `FittedBox` então dimensiona-se para o `Text` e permite que o `Text` tenha qualquer tamanho que desejar. Como o `FittedBox` e o `Text` têm o mesmo tamanho, não ocorre dimensionamento.
---
### Exemplo 20
---
No entanto, o que acontece se o `FittedBox` estiver dentro de um widget `Center`, mas o `Text` for muito grande para caber na tela?
---
O `FittedBox` tenta ajustar-se ao tamanho do `Text`, mas não pode ser maior do que a tela. Então ele assume o tamanho da tela e redimensiona o `Text` para que também caiba na tela.
---
### Exemplo 21
---
Se, no entanto, você remover o `FittedBox`, o `Text` obtém sua largura máxima da tela e quebra a linha para que caiba na tela.
---
### Exemplo 22
---
O `FittedBox` só pode dimensionar um widget limitado (com largura e altura não infinitas). Caso contrário, ele não renderizará nada e você verá um erro no console.
---
### Exemplo 23
---
A tela força a `Row` a ter exatamente o mesmo tamanho que a tela.
---
Assim como um `UnconstrainedBox`, a `Row` não impõe restrições aos seus filhos e, em vez disso, permite que eles tenham qualquer tamanho que desejarem. A `Row` então os coloca lado a lado, e qualquer espaço extra permanece vazio.
---
### Exemplo 24
---
Como a `Row` não impõe restrições aos seus filhos, é bem possível que os filhos sejam grandes demais para caber na largura disponível da `Row`. Nesse caso, assim como um `UnconstrainedBox`, a `Row` exibe o "aviso de estouro".
---
### Exemplo 25
---
Quando um filho de uma `Row` é envolvido por um widget `Expanded`, a `Row` não permite mais que esse filho defina sua própria largura.
---
Em vez disso, ela define a largura do `Expanded` de acordo com os outros filhos e, só então, o widget `Expanded` força o filho original a ter a largura do `Expanded`.
---
Em outras palavras, ao usar o `Expanded`, a largura original do filho se torna irrelevante e é ignorada.
---
### Exemplo 26
---
Se todos os filhos da `Row` estiverem envolvidos por widgets `Expanded`, cada `Expanded` terá um tamanho proporcional ao seu parâmetro flex e, só então, cada widget `Expanded` forçará seu filho a ter a largura do `Expanded`.
---
Em outras palavras, o `Expanded` ignora a largura preferida de seus filhos.
---
### Exemplo 27
---
A única diferença ao usar `Flexible` em vez de `Expanded`,
é que `Flexible` permite que seu filho tenha a mesma largura ou menor
que o próprio `Flexible`, enquanto `Expanded` força
seu filho a ter exatamente a mesma largura do `Expanded`.
Mas tanto `Expanded` quanto `Flexible` ignoram a largura de seus filhos
ao redimensionar a si mesmos.
---
{{site.alert.note}}
  Isso significa que é impossível expandir os filhos do `Row`
  proporcionalmente a seus tamanhos. O `Row` usa
  a largura exata do filho ou a ignora completamente
  quando você usa `Expanded` ou `Flexible`.
{{site.alert.end}}
---
### Exemplo 28
---
A tela força o `Scaffold` a ter exatamente o mesmo tamanho
que a tela, então o `Scaffold` preenche a tela.
O `Scaffold` diz ao `Container` que ele pode ter qualquer tamanho que quiser,
mas não maior que a tela.
---
{{site.alert.note}}
  Quando um widget diz ao seu filho que ele pode ser menor que um
  certo tamanho, dizemos que o widget fornece restrições _loose_
  para seu filho. Mais sobre isso depois.
{{site.alert.end}}
---
### Exemplo 29
---
Se você deseja que o filho do `Scaffold` tenha exatamente o mesmo tamanho
que o próprio `Scaffold`, você pode envolver seu filho com
`SizedBox.expand`.
---
{{site.alert.note}}
  Quando um widget diz ao seu filho que ele deve ter
  um determinado tamanho, dizemos que o widget fornece restrições _tight_
  para seu filho.
{{site.alert.end}}
---
## Restrições tight vs. loose
---
É muito comum ouvir que alguma restrição é
"tight" ou "loose", então vale a pena saber o que isso significa.
---
Uma restrição _tight_ oferece uma única possibilidade,
um tamanho exato. Em outras palavras, uma restrição tight
tem sua largura máxima igual à sua largura mínima;
e tem sua altura máxima igual à sua altura mínima.
---
Se você for ao arquivo `box.dart` do Flutter e procurar pelos
construtores `BoxConstraints`, encontrará o seguinte:
---
Se você revisitar [Exemplo 2](#example-2) acima,
ele nos diz que a tela força o `Container` vermelho
a ter exatamente o mesmo tamanho da tela.
A tela faz isso, é claro, passando restrições tight
ao `Container`.
---
Uma restrição _loose_, por outro lado,
define a largura e altura **máximas**, mas permite que o widget
seja tão pequeno quanto quiser. Em outras palavras,
uma restrição loose tem largura e altura **mínimas**
ambas iguais a **zero**:
---
Se você revisitou o [Exemplo 3] (#exemplo-3), ele nos diz que o
`Center` permite que o `Container` vermelho seja menor,
mas não maior que a tela. O `Center` faz isso,
é claro, passando restrições flexíveis para o `Container`.
Em última análise, o propósito do `Center` é transformar
as restrições rígidas que ele recebeu de seu pai
(a tela) em restrições flexíveis para seu filho
(o `Container`).
---
## Aprendendo as regras de layout para widgets específicos
---
Saber a regra geral de layout é necessário, mas não é suficiente.
---
Cada widget tem muita liberdade ao aplicar a regra geral,
então não há como saber o que ele fará apenas lendo
o nome do widget.
---
Se você tentar adivinhar, provavelmente vai errar.
Você não pode saber exatamente como um widget se comporta a menos que
tenha lido sua documentação ou estudado seu código-fonte.
---
O código-fonte de layout geralmente é complexo,
então provavelmente é melhor apenas ler a documentação.
No entanto, se você decidir estudar o código-fonte de layout,
você pode encontrá-lo facilmente usando as capacidades de navegação
do seu IDE.
---
Aqui está um exemplo:
---
* Encontre uma `Column` em seu código e navegue até o
  código-fonte. Para fazer isso, use `command+B` (macOS)
  ou `control+B` (Windows / Linux) no Android Studio ou IntelliJ.
  Você será levado ao arquivo `basic.dart`.
  Como `Column` estende `Flex`, navegue até o código-fonte de `Flex`
  (também em `basic.dart`).
---
* Role para baixo até encontrar um método chamado
  `createRenderObject()`. Como você pode ver,
  este método retorna um `RenderFlex`.
  Este é o objeto de renderização para a `Column`.
  Agora navegue até o código-fonte de `RenderFlex`,
  o que o leva ao arquivo `flex.dart`.
---
* Role para baixo até encontrar um método chamado
  `performLayout()`. Este é o método que faz
  o layout para a `Column`.
---
Artigo de Marcelo Glasberg
---
Marcelo publicou originalmente este conteúdo como
[Flutter: A Regra de Layout Avançada que até Iniciantes Devem Conhecer][]
no Medium. Adoramos e pedimos que ele nos permitisse publicar
em docs.flutter.dev, o qual ele concordou graciosamente. Obrigado, Marcelo!
Você pode encontrar Marcelo no [GitHub][] e [pub.dev][].
---
Também agradecemos a [Simon Lightfoot][] por criar o
imagem do cabeçalho no topo do artigo.
---
[documentação do `Container`]: {{site.api}}/flutter/widgets/Container-class.html
[DartPad instance]: {{site.dartpad}}/60174a95879612e500203084a0588f94
[Flutter: A Regra de Layout Avançada que até Iniciantes Devem Conhecer]: {{site.medium}}/flutter-community/flutter-the-advanced-layout-rule-even-beginners-must-know-edc9516d1a2
[GitHub]: {{site.github}}/marcglasberg
[pub.dev]: {{site.pub}}/publishers/glasberg.dev/packages
[Simon Lightfoot]: {{site.github}}/slightfoot
[este repositório GitHub]: {{site.github}}/marcglasberg/flutter_layout_article
---
