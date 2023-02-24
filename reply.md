* from the above steps I was not able to decide where the incorrect results may have happened; I wonder if there are any incorrect results in this case - as there is another issue in which compression is being interrupted; which leaves some garbage behind; although its not fortunate - it doesn't affect correctness; I wonder if this is a similar issue
* I see that there is no message/detail about the error `policy_compression_execute` encounters;
```
2023-02-17 06:43:46 UTC [25188-667] DETAIL:  Message: (), Detail: ().
```
however there is also a `2023-02-17 06:43:45 UTC [25188-663] LOG:  process 25188 detected deadlock while waiting for AccessExclusiveLock on relation 3692072478 of database 16402 after 1000.034 ms` ; I wonder 
