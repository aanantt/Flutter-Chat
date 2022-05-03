def function(name,*args, **kwargs):
    s = args
    k = kwargs["data"]
    print(k)


function("Name","Args","args1","args2","args3","args4","args5","args6",kwargs = "kwargs value",data = "data")