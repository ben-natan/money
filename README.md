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

Ils sont définis les uns par rapport aux autres (ou non) : 
`set USD = asset;` 
`set EUR = asset 1.2 of USD;` (1 EUR = 1.2 USD)
On a alors `EUR.USD` = 1.2 et `USD.EUR`= 0.83


## Wallet
Des quantités d'assets sont contenues dans un wallet : 
`set w1 = wallet { USD: 10, EUR: 20 }`
On peut accéder à une certaine quantité avec `w.EUR`

Il est possible d'ajouter plusieurs wallets entre eux, ainsi que d'effectuer des multiplications par des constantes. 
`set w2 = wallet { GBP: 3, EUR: 5 };`
`w1 + w2;`  donne  `{ USD: 10, GBP: 3, EUR: 25 }`
`3*w2;` donne `{ GBP: 9, EUR: 15}`
`w2 + { EUR: 5 };` donne `{ GBP: 3, EUR: 10 }`

## Transaction
À partir d'un wallet il est possible d'effectuer des transactions :  
`set t = buy 2 of USD with w1 through EUR;` 
effectuera une transaction pour que l'on ait `w1 = { USD: 12, EUR: 18.33 }` et 
 `t = { success: true, from: EUR, to: USD, price: 1.67, amount: 2 }`
 Dans le cas où les fonds ne sont pas suffisants , la transaction n'est pas réalisée.
 On peut accéder directement à un champ avec `t.success` par exemple.

## Exemples & fonctionnement
 - Pour la ménagère qui souhaite faire ses courses :

`set EUR = asset;`
`set w = wallet { EUR: 55 };`

`set tomate = asset 2.4 of EUR;`
`set t_tomates  = buy 3 of tomate with w through EUR;`
...
`w;; `

Avec un import automatique des assets de carrefour par exemple, elle peut tenir sa liste de courses.

- Pour le trader :

`set EUR = asset`
`set USD = asset 0.8 of EUR` ( à récupérer automatiquement )
`set w = wallet { EUR: 100, USD: 100 }`
`set maxUSD = w.EUR * USD.EUR;`

`if EUR.USD < 0.8 then`
	   `set t = buy maxUSD of USD with w through EUR` 

`t;;`

- Pour un comptable : 

`set budget_total = wallet { EUR: 8000, lingot_or: 4 };`
`set budget_anniversaires = 30% * budget_total;`

`set champagne = asset 15 of EUR;`
`set gateau = asset 10 of EUR;`
`set anniv_antoine = wallet { champagne: 4, gateau: 1};`

`buy anniv_antoine.champagne of champagne with budget_anniversaire through EUR`
`buy anniv_antoine.gateau of gateau with budget_anniversaire through EUR`;




## TODO
- ~~Un Buy With Through est obligatoirement égal à une transac~~

- ~~Changer les int en float (et le -n en 1/n)~~

- ~~Boucle while (boucle for = boucle while intelligente)~~

- ~~Régler les shift/reduce~~

- ~~Fonctions~~

- ~~Opérateurs sur les assets~~

- ~~Messages d'erreur~~ 
 
- type fonction .EUR