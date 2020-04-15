
#include <iostream>

#include <llvm/IR/Instructions.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IRReader/IRReader.h>
#include <llvm/Support/SourceMgr.h>

int main(int argc, const char *argv[]) {
    if (argc != 2) {
        llvm::errs() << "usage: " << argv[0] << " bitcode\n";
        std::exit(1);
    }

    llvm::LLVMContext ctx;
    llvm::SMDiagnostic err;
    std::unique_ptr<llvm::Module> m = parseIRFile(argv[1], err, ctx);

    if (!m) {
        llvm::errs() << "usage: " << argv[0] << " bitcode\n";
        std::exit(2);
    }

    unsigned loads  = 0, ctirLoads  = 0,
             stores = 0, ctirStores = 0,
             geps   = 0, ctirGeps   = 0;

    for (llvm::Function &f : *m) {
        for (llvm::BasicBlock &bb : f) {
            for (llvm::Instruction &i : bb) {
                if (llvm::isa<llvm::LoadInst>(i)) {
                    ++loads;
                    if (i.getMetadata("ctir")) ++ctirLoads;
                } else if (llvm::isa<llvm::StoreInst>(i)) {
                    ++stores;
                    if (i.getMetadata("ctir")) ++ctirStores;
                } else if (llvm::isa<llvm::GetElementPtrInst>(i)) {
                    ++geps;
                    if (i.getMetadata("ctir")) ++ctirGeps;
                }
            }
        }
    }

    llvm::outs() << "======= " << argv[1] << " =======\n";
    llvm::outs() << "Loads  " << loads  << " (" << ctirLoads  << ")\n";
    llvm::outs() << "Stores " << stores << " (" << ctirStores << ")\n";
    llvm::outs() << "GEPs   " << geps   << " (" << ctirGeps   << ")\n";
}

