import math
import check
# Data definition for Q3 + Q4

# A MineGrid is a (listof (listof Bool))
# Requires:  All lists are non-empty
#            Each (listof Bool) has the same length 

# note: True means mine, False means safe

# A MineBoard is a (listof (listof Str))
# Requires: Each string is either a mine ('*') hidden(' ')
#             or safe (a digit between '0' and '8')
#           All lists are non-empty
#           Each (listof Str) has the same length


grid3x3 = [[True ,False,False],
           [False,False,False],
           [False,False,True]]

board3x3 = [[' ', '1', '0'],
            [' ', '2', '1'],
            [' ', ' ', '*']]


## Question 3
# reveal(grid,board, row, col) reveals the tile at the given row and col(umn)
#   in board, using the mine positions from grid
# reveal: MineGrid MineBoard -> None
# requires: grid and board have the same dimensions and are consistent
#           0 <= row < height of board
#           0 <= col < width  of board
# effects: board is mutated

def reveal(grid,board,row,col):
    if grid[row][col]:
        board[row][col] = '*'
    else:
        board[row][col] = str(count_mines(grid,row,col))

grid3x3 = [[True ,False,False],
           [False,False,False],
           [False,False,True]]


grid1x1 = [[True]]

grid1x1_2 =[[False]]

grid1x2 =[[True,False]]

grid1x5 =[[True,False,False,False,True]]

grid1x20 = [[True,True,False,False,True,True,False,False,False,True,\
            False,False,True,True,False,True,False,False,True,True]]

grid2x2 = [[True,False],[False,True]]

grid2x2_1 = [[True,True],[False,False]]

grid2x3 = [[True,False,True],
           [True,False,False]]

grid5x1 = [[True] ,[False],[False],[True],[False]]

grid7x5 = [[True,False,False,False,True],
           [True,False,True,False,True],
           [False,False,True,True,True],
           [False,False,True,True,True],
           [False,False,False,False,True],
           [True,False,False,False,True],
           [True,False,True,True,True]]           

# count_mines_helper(grid,rwo,col) returns zero is integral row is nagative 
#   or integral col or row equals to the length grid or col equals to the length
#   of the first row of grid. If grid[row][cil] is True, then returns 0. 
#   Otherwise, return 0.
# count_mines_helper: MineGrid Int Int -> Nat
# Examples:
# count_mines_helper(grid1x1,0,0) => 0
# count_mines_helper(grid3x3,2,2) => 1

def count_mines_helper(grid,row,col):
    if row < 0 or col < 0 or row == len(grid) or col == len(grid[0]):
        return 0
    elif grid[row][col] == True:
        return 1
    else:
        return 0 

# count_mines(grid,row,col)consumes a MineGrid, a natural number row and another
#   natural number col. It will return how many mines tiles that are adjacent to 
#   the tile at that position.
# count_mines: MineGrid Nat Nat -> Nat
# Examples:
# count_mines(grid3x3,0,0) => 0
# count_mines(grid3x3,1,1) => 0   
def count_mines(grid,row,col):
    return count_mines_helper(grid,row-1,col-1)+count_mines_helper(grid,row-1,col)+\
           count_mines_helper(grid,row-1,col+1)+count_mines_helper(grid,row,col-1)+\
           count_mines_helper(grid,row,col+1)+count_mines_helper(grid,row+1,col-1)+\
           count_mines_helper(grid,row+1,col)+count_mines_helper(grid,row+1,col+1)    
# Tests:
check.expect("t1",count_mines(grid3x3,0,0),0)
check.expect("t2",count_mines(grid3x3,1,1),2)
check.expect("t3",count_mines(grid1x1,0,0),0)
check.expect("t5",count_mines(grid1x2,0,1),1)
check.expect("t6",count_mines(grid1x2,0,0),0)
check.expect("t7",count_mines(grid1x5,0,0),0)
check.expect("t8",count_mines(grid1x5,0,4),0)
check.expect("t9",count_mines(grid1x5,0,1),1)
check.expect("t10",count_mines(grid1x20,0,0),1)
check.expect("t11",count_mines(grid1x20,0,19),1)
check.expect("t12",count_mines(grid1x20,0,10),1)
check.expect("t13",count_mines(grid2x2,0,0),1)
check.expect("t14",count_mines(grid2x2,0,1),2)
check.expect("t15",count_mines(grid2x2,1,0),2)
check.expect("t16",count_mines(grid2x2,1,1),1)
check.expect("t17",count_mines(grid2x2_1,0,1),1)
check.expect("t18",count_mines(grid2x3,0,0),1)
check.expect("t19",count_mines(grid2x3,0,1),3)
check.expect("t20",count_mines(grid2x3,0,2),0)
check.expect("t21",count_mines(grid2x3,1,0),1)
check.expect("t22",count_mines(grid2x3,1,2),1)
check.expect("t23",count_mines(grid2x3,1,1),3)
check.expect("t24",count_mines(grid5x1,0,0),0)
check.expect("t25",count_mines(grid5x1,4,0),1)
check.expect("t26",count_mines(grid5x1,3,0),0)
check.expect("t27",count_mines(grid7x5,0,0),1)
check.expect("t28",count_mines(grid7x5,0,4),1)
check.expect("t29",count_mines(grid7x5,6,4),2)
check.expect("t30",count_mines(grid7x5,6,0),1)
check.expect("t31",count_mines(grid7x5,0,3),3)
check.expect("t32",count_mines(grid7x5,3,0),0)
check.expect("t33",count_mines(grid7x5,6,2),1)
check.expect("t34",count_mines(grid7x5,2,3),7)
check.expect("t35",count_mines(grid7x5,3,3),6)

# Examples
grid1x1 = [[True]]
board1x1_w = [[' ']]
board1x1_l = [['*']]

grid1x2 =[[True,False]]
board1x2_w = [[' ','1']]
board1x2_l = [['*',' ']]

grid1x5 = [[True,False,False,False,True]]
board1x5_l =[['*',' ', '0',' ',' ']]
board1x5_w = [[' ','1','0','1',' ']]
 
grid2x5 = [[True,False,True,False,True],
           [True,False,True,False,True]]
board2x5 =[[' ',' ',' ','4',' '],
           [' ','4',' ','4',' ']]
           

grid5x1 = [[True] ,[False],[False],[True],[False]]
board5x1_l = [[' '],['1'],['1'],['*'],[' ']]
board5x1_w = [[' '],['1'],['1'],[' '],['1']]

grid3x3 = [[True ,False,False],
           [False,False,False],
           [False,False,True]]
board3x3_l = [[' ', '1', '0'],
            [' ', '2', '1'],
            [' ', ' ', '*']]

board3x31_w = [[' ', '1', '0'],
            ['1', '2', '1'],
            ['0', ' 1', ' ']]

grid4x4 = [[True,False,False,True],
           [False,True,False,False],
           [False,True,False,True],
           [False,True,False,True]]
board4x4_l = [['*', '2', '2',' '],
              ['3', ' ', '3','2'],
              ['3', ' ', '5',' '],
              ['2', ' ', '4',' ']]
board4x4_w =  [[' ', '2', '2',' '],
               ['3', ' ', '3','2'],
               ['3', ' ', '5',' '],
               ['2', ' ', '4',' ']]



# game_lost(board) returns true if board contains one or more revealed mines,
#   false otherwise
# game_lost: GameBoard -> Bool

def game_lost(board):
    mined_rows = len(list(filter(lambda row: '*' in row, board)))
    return mined_rows != 0
# search_item(target,item,cons) returns zero if cons equal to the length of 
#   target otherwise it will return all itmes in the lists of target.
# search_item: (Anyof MineGrid GameBoard) Str Nat -> Nat
# Requires: cons == 0
# Examples:
# search_item(grid3x3,'True',0) => 2
# search_item(board3x3_l,' ',0) => 4
def search_item(target,item,cons):
    if cons == len(target):
        return 0
    else:
        return len(list(filter(lambda x: x == item,target[cons]))) + \
               search_item(target,item,cons+1)

# game_won(grid,board) returns true if board contains all revealed safe tile and 
#   all mine tiles are not revealed. Otherwise, it returns false.
# game_won: MineGrid GameBoard -> Bool
# Examples:
# game_won(grid3x3,board3x3) => False
# game_won(grid4x4,board4x4_w) => True
def game_won(grid,board):
    if search_item(board,'*',0)== 0 and\
       search_item(board,' ',0) == search_item(grid,True,0):
        return True
    else: return False

# Tests:
check.expect("T1",game_won(grid3x3,board3x3_l),False)
check.expect("T2",game_won(grid3x3,board3x31_w),True)
check.expect("T3",game_won(grid4x4,board4x4_l),False)
check.expect("T4",game_won(grid4x4,board4x4_w),True)
check.expect("T5",game_won(grid1x1,board1x1_l),False)
check.expect("T6",game_won(grid1x1,board1x1_w),True)
check.expect("T7",game_won(grid1x2,board1x2_l),False)
check.expect("T8",game_won(grid1x2,board1x2_w),True)
check.expect("T9",game_won(grid1x5,board1x5_l),False)
check.expect("T10",game_won(grid1x5,board1x5_w),True)
check.expect("T11",game_won(grid5x1,board5x1_l),False)
check.expect("T12",game_won(grid5x1,board5x1_w),True)
check.expect("T13",game_won(grid2x5,board2x5),False)