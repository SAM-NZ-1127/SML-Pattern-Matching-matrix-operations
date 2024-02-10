fun rowToString [] = ""
  | rowToString (matrix::m2) = Int.toString(matrix) ^ " " ^ rowToString(m2);

fun matrixToString [] = ""
  | matrixToString (matrix::m2) = rowToString(matrix) ^ "\n" ^ matrixToString(m2);

fun matrixAdd (matrix1, matrix2) =
    let
        fun addRows ([], []) = []
          | addRows (r1::rest1, r2::rest2) =
                let
                    fun addElements ([], [], result) = result
                      | addElements (x::xs, y::ys, result) =
                            addElements (xs, ys, x + y :: result)
                in
                    rev (addElements (r1, r2, [])) :: addRows (rest1, rest2)
                end
    in
        addRows (matrix1, matrix2)
    end;

fun transpose ([]::_) = []
  | transpose rows =
    let
      fun getColumn (r::rest) = hd r :: getColumn rest
        | getColumn [] = []
    in
      getColumn rows :: transpose (map tl rows)
    end;

fun dotProduct (v1, v2) =
    let
        fun dot ([], [], result) = result
          | dot (x::xs, y::ys, result) = dot (xs, ys, x * y + result)
    in
        dot (v1, v2, 0)
    end;

fun scalarMatrixProduct (s, m) =
    let
        fun scaleRow ([], result) = rev result
          | scaleRow (x::xs, result) = scaleRow (xs, (s * x) :: result)
        fun scaleRows ([], result) = result
          | scaleRows (row::rest, result) =
                scaleRows (rest, scaleRow (row, []) :: result)
    in
        rev (scaleRows (m, []))
    end;

fun matrixProduct(m1, m2) =
    let
        val transposedMatrix2 = transpose m2
        fun multiplyRowWithColumn(_, [], []) = 0
          | multiplyRowWithColumn([], _, []) = 0
          | multiplyRowWithColumn(row1::rest1, col2::rest2, accum) =
                row1 * col2 + multiplyRowWithColumn(rest1, rest2, accum)
        fun multiplyRowsWithColumns([], _, result) = rev result
          | multiplyRowsWithColumns(row1::rows1, cols2, result) =
                let
                    val newRow = multiplyRowWithColumnsHelper(row1, cols2, [])
                in
                    multiplyRowsWithColumns(rows1, cols2, newRow :: result)
                end
        and multiplyRowWithColumnsHelper(_, [], result) = rev result
          | multiplyRowWithColumnsHelper(row1, col2::cols2, result) =
                let
                    val product = multiplyRowWithColumn(row1, col2, [])
                in
                    multiplyRowWithColumnsHelper(row1, cols2, product :: result)
                end
    in
        multiplyRowsWithColumns(m1, transposedMatrix2, [])
    end;

val show = print o matrixToString;
val x = [[1,2,3], [4,5,6], [7,8,9]];
val y = [[1,1,1],[2,2,2],[3,3,3]];

show (matrixAdd(x,y));
dotProduct ([1,2,3],[4,5,6]);
show (transpose x);
show (scalarMatrixProduct (10, x));
show (matrixProduct (x, y));