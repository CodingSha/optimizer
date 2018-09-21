# optimizer
iOS开发过程中积累的程序优化工具，包括UI的顺序执行，自定义可挂起和重启的Timer，UI线程的优化以及控制

### BDLAlertSequenceManager
通过信号量和一个异步串行队列管理alert等UI的顺序弹出，用法超级简单，只需要把UI的初始化代码提交到管理类，在UI消失的时候free掉即可。
### GCDTimer
使用GCD自定义的Timer，不会受到滑动视图的影响，可以暂停，可以重启，可以取消。
### SteadilyTrackingOptimizer
监听了UI线程，可以通过自主控制一些卡顿主线程的任务的执行时机，从而解决一些卡顿问题。

