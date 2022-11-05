## lab10:
The first part is easy.

Note that when implementing dotp_manual, we'd better notice where the local_sum is, we should put this into the right place to tell the compiler that we want every thread has a local_sum.

The second part note:
the father process should always be there, after we fork a child process, we cantransfer the task to it, while the fater process keeps giving birth to a new child.

when these processes comes simulataneously, the father process can always give birth in time to `dispatch` a new request.
