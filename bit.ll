declare i8* @calloc(i32, i32)
declare void @free(i8*)

define i32 @main() {
  ; Allocate 30,000 cells on the heap.
  %cells = call i8* @calloc(i32 30000, i32 1)

  ; Allocate a stack variable to track the cell index.
  %cell_index_ptr = alloca i32
  ; Initialise it to zero.
  store i32 0, i32* %cell_index_ptr

  ;;;;;;;;;;;;;;;;;;;;
%cell_index = load i32* %cell_index_ptr
%cell_ptr = getelementptr i8* %cells, i32 %cell_index

%current_cell = load i8* %cell_ptr
%current_cell_word = sext i8 %current_cell to i32
call i32 @putchar(i32 %current_cell_word)
  ;;;;;;;;;;;;;;;;;;;;

  ; Free the memory for the cells.
  call void @free(i8* %cells)
  ret i32 0
}
