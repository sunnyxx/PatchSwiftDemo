使用 `mprotect` Patch 纯 Swift 方法的 Demo，真机不可用 

``` objc
void patchSwift(void) {
    
    // 根据符号获取要 patch swift 方法地址
    void *handle = dlopen(NULL/* current image */, RTLD_GLOBAL);
    // 这个符号 nm 取到的，dlsym 会在符号前加下划线
    // 根据 swift name mangling 可以动态生成这个串
    int64_t *swiftFunc = dlsym(handle, "_TFC14PatchSwiftDemo4Sark3foofSiSi");
    int64_t *newFunc = (int64_t *)&patchedFunction;
    
    // 原函数和 patch 函数的 offset
    int64_t offset = (int64_t)newFunc - ((int64_t)swiftFunc + 5 * sizeof(char));
    
    // 将代码区这个 page 改成可写
    size_t pageSize = sysconf(_SC_PAGESIZE);
    uintptr_t start = (uintptr_t)swiftFunc;
    uintptr_t end = start + 1;
    uintptr_t pageStart = start & -pageSize;
    // 注意，这个方法在非越狱 iOS 真机被禁用
    mprotect((void *)pageStart, end - pageStart, PROT_READ | PROT_WRITE | PROT_EXEC);

    // swift 函数第一行指令改成 jmp offset
    int64_t instruction = 0xe9 | offset << 8;
    *swiftFunc = instruction;
}
```