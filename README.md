# MONEY

## Introduction

Money est un langage de programmation qui permet facilement d'effectuer des calculs sur des porte-monnaies.

## Types
- float, bool et string
- wallet
- asset
- transaction
- func

## Asset
Les assets sont des 'objets' de valeur.
> Exemple: USD, baguette de pain..

Ils sont définis les uns par rapport aux autres (ou non) : </br>
`set USD = asset;` </br>
`set EUR = asset 1.2 of USD;` (1 EUR = 1.2 USD) </br>
On a alors `EUR.USD` = 1.2 et `USD.EUR`= 0.83 .


## Wallet
Des quantités d'assets sont contenues dans un wallet : </br>
`set w1 = wallet { USD: 10, EUR: 20 }`</br>
On peut accéder à une certaine quantité avec `w1.EUR` . 

Il est possible d'ajouter plusieurs wallets entre eux, ainsi que d'effectuer des multiplications par des constantes. </br>
`set w2 = wallet { GBP: 3, EUR: 5 };` . </br>
`w1 + w2;`  donne  `{ USD: 10, GBP: 3, EUR: 25 }` . </br>
`3*w2;` donne `{ GBP: 9, EUR: 15}` . </br>
`w2 + { EUR: 5 };` donne `{ GBP: 3, EUR: 10 }` .

## Transaction
À partir d'un wallet il est possible d'effectuer des transactions :  </br>
`set t = buy 2 of USD with w1 through EUR;` </br>
effectuera une transaction pour que l'on ait `w1 = { USD: 12, EUR: 18.33 }` et </br>
 `t = { success: true, from: EUR, to: USD, price: 1.67, amount: 2, wallet: w1 }` </br>
 Dans le cas où les fonds ne sont pas suffisants , la transaction n'est pas réalisée. </br>
 On peut accéder directement à un champ avec `t.success` par exemple.

## Exemples d'utilisation
 - Pour la ménagère qui souhaite faire ses courses : 

`set EUR = asset;` </br>
`set w = wallet { EUR: 55 };` </br>

`set tomate = asset 2.4 of EUR;` </br>
`set t_tomates  = buy 3 of tomate with w through EUR;` </br>
... </br>
`w;; ` </br>

Avec un import automatique des assets de carrefour par exemple, elle peut tenir sa liste de courses.

- Pour le trader :

`set EUR = asset` </br>
`set USD = asset 0.8 of EUR` ( à récupérer automatiquement ) </br>
`set w = wallet { EUR: 100, USD: 100 }` </br>
`set maxUSD = w.EUR * USD.EUR;` </br>

`if EUR.USD < 0.8` </br>
`then set t = buy maxUSD of USD with w through EUR; t`  </br>
`else set t = buy 0 of USD with w through EUR; t;;`

- Pour un comptable : 

`set budget_total = wallet { EUR: 8000, lingot_or: 4 };` </br>
`set budget_anniversaires = 30% * budget_total;` </br>

`set champagne = asset 15 of EUR;` </br>
`set gateau = asset 10 of EUR;` </br>
`set anniv_antoine = wallet { champagne: 4, gateau: 1};` </br>

`buy anniv_antoine.champagne of champagne with budget_anniversaire through EUR;` </br>
`buy anniv_antoine.gateau of gateau with budget_anniversaire through EUR;`


## Compilation

`make depend`, `make` construisent l'interprêteur `mnyloop` qui s'utilise en mode interactif en lançant `./mnyloop` ou alors à partir d'un fichier avec `./mnyloop fichier.mny`. </br>

Des exemples de programmes `.mny` sont dans le dossier `/scripts` .
