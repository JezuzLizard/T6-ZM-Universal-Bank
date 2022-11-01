# T6-ZM-Universal-Bank
A banking plugin that uses a player's stats file instead of creating a database.

This one does not require any external dependencies and does not require you to create and use a database.
The player's bank account is based off of their stats file so their balance will exist in custom games and servers too.
This mod works on every map(except grief maps) and allows players to access their bank account from chat commands.
So even maps without a normal bank trigger you can still access your balance through the chat.

Due to stat file limitations the max bank value is 250000. This cannot be increased.

This mod handles every edge I could find so it should be very stable and be unlikely to have undefined behavior.

# Commands
Withdraw -
```
.w 
.with
.withdraw
```
Deposit -
```
.d
.dep
.deposit
```
Balance -
```
.b
.bal
.balance
```

Examples
```
.w 1000
.d 1000
.b
```

