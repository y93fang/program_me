;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname Compilers) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; a FileFormat is (anyof 'x 'y 'z)

(define-struct file (size format))
;; a File is a (make-file Nat FileFormat)
;; requires:
;;     format represents the file format (similar to .jpg or .rkt
;;       in a real computer)
;;     size represents how much space it uses on the computer

(define-struct folder (files subfolders))
;; a Folder is a (make-folder (listof File) (listof Folder))
;; requires:
;;      files represents all of the files directly in this folder
;;      subfolders represents the folders directly in this folder

(define f10x (make-file 10 'x))
(define f25y (make-file 25 'y))
(define f30x (make-file 30 'x))
(define f25x (make-file 25 'x))
(define f10y (make-file 10 'y))
(define f10z (make-file 10 'z))
(define f30x-copy (make-file 30 'x))
(define f10z-copy (make-file 10 'z))
(define f50y (make-file 50 'y))
(define f30z (make-file 30 'z))
(define f0x (make-file 0 'x))
(define f50z (make-file 50 'z))
(define fldA (make-folder (list f10x f25y f30z) empty))
(define fldB (make-folder (list f25x f30x-copy) empty))
(define fldC (make-folder (list f10z f10y f50y) empty))
(define fldD (make-folder (list f10z-copy f30x) (list fldA)))
(define fldE (make-folder empty (list fldB fldC)))
(define fldF (make-folder (list f0x f50z) (list fldD fldE)))
(define fldG (make-folder (list f0x f50z) (list fldD fldE fldA)))
(define fldH (make-folder (list f0x f50z f30x-copy) (list fldD fldE fldB fldC)))


;;(all-size-true fld)produces the total size of all files of
;; type fmt in both fld and all subfolders by consuming a
;; Folder.
;; all-size-true: Folder-> Int
;; Example:
(check-expect (all-size-true fldE)125)

(define (all-size-true fld)
  (local
    [;; (extract-size files) produces the total size of files in a list of file.
     ;; extract-size: (listof files)-> Int
     (define (extract-size files)
       (cond
         [(empty? files) 0]
         [else (+ (file-size (first files))
                  (extract-size (rest files)))]))
     ;;(size-in-list lof)produces the total size of subfolders in a list of Folder.
     ;;size-in-list:(listof Folder)-> Int
     (define (size-in-list lof)
       (cond
         [(empty? lof)0]
         [else (+ (all-size-true (first lof))
                  (size-in-list (rest lof)))]))]
 (+ (extract-size (folder-files fld))
    (size-in-list (folder-subfolders fld)))))

;;(size-false fld)produces the total size of all files directly in Folder,fld.
;; size-false: Folder-> Int
;; Example:
(check-expect (size-false fldE)0) 

(define (size-false fld)
   (local
    [;; (extract-size files)produces the total size of files in a list of file.
     ;; extract-size: (listof files)-> Int
     (define (extract-size files)
       (cond
         [(empty? files) 0]
         [else (+ (file-size (first files))
                  (extract-size (rest files)))]))]
 (extract-size (folder-files fld))))

;;(filformat-true fmt fld)produces the total size of files with specific
;; FileFormat,fmt, in both fld and all subfolders by consuming a
;; Folder.
;; filformat-true: FileFormat Folder-> Int
;; Example:
(check-expect (filformat-true 'z fldF)100)

(define (filformat-true fmt fld)
  (local
    [;; (extract-size-specific files)produces the total size of files with specific
     ;; FileFormat,fmt in a list of file.
     ;; extract-size-specific: (listof files)-> Int
     (define (extract-size-specific files)
       (cond
         [(empty? files) 0]
         [(empty? (filter (lambda (x)(equal? (file-format x)fmt)) files)) 0]
         [else (+(file-size (first (filter (lambda (x)
                                           (equal? (file-format x)fmt)) files)))
               (extract-size-specific (rest (filter (lambda (x)
                                           (equal? (file-format x)fmt)) files))))])) 
     ;;(size-in-fileformat lof)produces the total size of subfolders with specific
     ;; FileFormat,fmt in a list of Folder.
     ;;size-in-fileformat:(listof Folder)-> Int
     (define (size-in-filformat lof)
       (cond
         [(empty? lof)0]
         [else (+ (filformat-true fmt (first lof))
                  (size-in-filformat (rest lof)))]))]
 (+ (extract-size-specific (folder-files fld))
     (size-in-filformat (folder-subfolders fld)))))

;;(filformat-false fmt fld)produces the total size of all files with specific
;; FileFormat,fmt, directly in Folder,fld.
;; filformat-false: FileFormat Folder-> Int
;; Example:
(check-expect (filformat-false 'x fldB)55)

(define (filformat-false fmt fld)
   (local
    [;; (extract-size-specific files)produces the total size of files with specific
     ;; FileFormat,fmt in a list of file.
     ;; extract-size-specific: (listof files)-> Int
     (define (extract-size-specific files)
       (cond
         [(empty? files) 0]
         [(empty? (filter (lambda (x)(equal? (file-format x)fmt)) files)) 0]
         [else (+(file-size (first (filter (lambda (x)
                                           (equal? (file-format x)fmt)) files)))
               (extract-size-specific (rest (filter (lambda (x)
                                           (equal? (file-format x)fmt)) files))))]
         ))]
 (extract-size-specific (folder-files fld))))

;;(total-size fld fmt deep-check?)consumes a Folder,fld,a FileFormat,fmt,or the symbol
;;'all and a Boolen value,deep-check?)and it will produce the total size of all files of
;; type are either directly in fld is deep-check?is false or directly in fld and subfolders.
;; total-size: Folder (anyof FileFormat symbol) Bool-> Int
;; Examples:
(check-expect (total-size fldE 'all false)0)
(check-expect (total-size fldE 'all true) 125)

(define (total-size fld fmt deep-check?)
  (cond
    [(and (equal? 'all fmt)(equal? true deep-check?))
     (all-size-true fld)]
    [(and(equal? 'all fmt)(equal? false deep-check?))
     (size-false fld)]
    [(and(or (equal? fmt 'x)(equal? fmt 'y)(equal? fmt 'z))
         (equal? true deep-check?))
     (filformat-true fmt fld)]
    [(and(or (equal? fmt 'x)(equal? fmt 'y)(equal? fmt 'z))
         (equal? false deep-check?))
     (filformat-false fmt fld)]))

;;Tests:
(check-expect (total-size (make-folder empty empty)'all true)0)
(check-expect (total-size fldA 'all true)65)
(check-expect (total-size fldA 'x true)10)
(check-expect (total-size fldA 'z true)30)
(check-expect (total-size fldA 'y true)25)
(check-expect (total-size fldA 'all false)65)
(check-expect (total-size fldA 'x false)10)
(check-expect (total-size fldA 'z false)30)
(check-expect (total-size fldA 'y false)25)
(check-expect (total-size fldB 'all true)55)
(check-expect (total-size fldB 'x true)55)
(check-expect (total-size fldB 'z true)0)
(check-expect (total-size fldB 'y true)0)
(check-expect (total-size fldB 'all false)55)
(check-expect (total-size fldB 'x false)55)
(check-expect (total-size fldB 'z false)0)
(check-expect (total-size fldB 'y false)0)
(check-expect (total-size fldC 'all true)70)
(check-expect (total-size fldC 'x true)0)
(check-expect (total-size fldC 'z true)10)
(check-expect (total-size fldC 'y true)60)
(check-expect (total-size fldC 'all false)70)
(check-expect (total-size fldC 'x false)0)
(check-expect (total-size fldC 'z false)10)
(check-expect (total-size fldC 'y false)60)
(check-expect (total-size fldD 'all true)105)
(check-expect (total-size fldD 'x true)40)
(check-expect (total-size fldD 'z true)40)
(check-expect (total-size fldD 'y true)25)
(check-expect (total-size fldD 'all false)40)
(check-expect (total-size fldD 'x false)30)
(check-expect (total-size fldD 'z false)10)
(check-expect (total-size fldD 'y false)0)
(check-expect (total-size fldE 'all true)125)
(check-expect (total-size fldE 'x true)55)
(check-expect (total-size fldE 'z true)10)
(check-expect (total-size fldE 'y true)60)
(check-expect (total-size fldE 'all false)0)
(check-expect (total-size fldE 'x false)0)
(check-expect (total-size fldE 'z false)0)
(check-expect (total-size fldE 'y false)0)
(check-expect (total-size fldF 'z false)50)
(check-expect (total-size fldF 'all true)280)
(check-expect (total-size fldF 'z true)100)
(check-expect (total-size fldF 'all false)50)
(check-expect (total-size fldF 'all false)50)
(check-expect (total-size fldG 'y true)110)
(check-expect (total-size fldG 'all true)345)
(check-expect (total-size fldG 'x true)105)
(check-expect (total-size fldG 'z true)130)
(check-expect (total-size fldG 'y true)110)
(check-expect (total-size fldG 'all false)50)
(check-expect (total-size fldG 'x false)0)
(check-expect (total-size fldG 'z false)50)
(check-expect (total-size fldG 'y false)0)
(check-expect (total-size fldH 'all true)435)
(check-expect (total-size fldH 'x true)180)
(check-expect (total-size fldH 'z true)110)
(check-expect (total-size fldH 'y true)145)
(check-expect (total-size fldH 'all false)80)
(check-expect (total-size fldH 'x false)30)
(check-expect (total-size fldH 'z false)50)
(check-expect (total-size fldH 'y false)0)

              
;; a FileFormat is (anyof 'x 'y 'z)

(define-struct file (size format))
;; a File is a (make-file Nat FileFormat)
;; requires:
;;     format represents the file format (similar to .jpg or .rkt
;;       in a real computer)
;;     size represents how much space it uses on the computer

(define-struct folder (files subfolders))
;; a Folder is a (make-folder (listof File) (listof Folder))
;; requires:
;;      files represents all of the files directly in this folder
;;      subfolders represents the folders directly in this folder

(define f10x (make-file 10 'x))
(define f25y (make-file 25 'y))
(define f30x (make-file 30 'x))
(define f25x (make-file 25 'x))
(define f10y (make-file 10 'y))
(define f10z (make-file 10 'z))
(define f30x-copy (make-file 30 'x))
(define f10z-copy (make-file 10 'z))
(define f50y (make-file 50 'y))
(define f30z (make-file 30 'z))
(define f0x (make-file 0 'x))
(define f50z (make-file 50 'z))
(define fldA (make-folder (list f10x f25y f30z) empty))
(define fldB (make-folder (list f25x f30x-copy) empty))
(define fldC (make-folder (list f10z f10y f50y) empty))
(define fldD (make-folder (list f10z-copy f30x) (list fldA)))
(define fldE (make-folder empty (list fldB fldC)))
(define fldF (make-folder (list f0x f50z) (list fldD fldE)))
(define fldG (make-folder (list f10x)empty))
(define fldH (make-folder (list f10x f30z)empty))
(define fldI (make-folder (list f10x f25y f30x f50y)empty))
(define fldJ (make-folder (list f10x f25y f30z)(list fldA fldB)))
(define fldK (make-folder empty (list fldB)))
(define fldM (make-folder empty (list fldB fldD)))

;;(convert old-fml new-fml fld)consumes an old FileFormat, old-fml, and a new
;; FileFormat, new-fml and also a Folder to produce a Folder with each file of
;; the old format type is replaced by the new format type.
;; convert: FileFormat FileFormat Folder -> Folder
;; Examples:
(check-expect (convert 'x 'z fldA)
              (make-folder (list (make-file 10 'z) (make-file 25 'y)(make-file 30 'z))
                           empty))

(check-expect (convert 'x 'y fldE)
              (make-folder empty
                           (list
                            (make-folder (list (make-file 25 'y)
                                               (make-file 30 'y))
                                         empty)
                            (make-folder (list (make-file 10 'z)
                                               (make-file 10 'y)
                                               (make-file 50 'y))
                                         empty))))

(define (convert old-fml new-fml fld)
  (local
    [;;(change-fml files)consumes a list of files and produes a new list of files
     ;; by replaced all old FileFormat into new FileFormat.
     ;;change-fml: (listof file)->(listof file)
     (define (change-fml files)
       (cond
         [(empty? files) empty]
         [(equal? old-fml (file-format (first files)))
          (cons (make-file (file-size(first files)) new-fml)
                (change-fml (rest files)))]
         [else (cons (first files)(change-fml (rest files)))]))
     ;;(convert-subflds lof)consumes a list of folders and produces a new list of
     ;; folders by replacing all old FileFormat into new FileFormat
     ;; convert-subflds:(listof folders)->(listof folders)
     (define (convert-subflds lof)
       (cond
         [(empty? lof)empty]
         [else (cons (convert old-fml new-fml (first lof))
                  (convert-subflds (rest lof)))]))]
 (make-folder (change-fml (folder-files fld))
     (convert-subflds (folder-subfolders fld)))))

;;Tests:
(check-expect (convert 'y 'y fldF)fldF)
(check-expect (convert 'z 'y fldG)
               (make-folder (list (make-file 10 'x)) empty))
(check-expect (convert 'y 'z fldH)
              (make-folder (list (make-file 10 'x) (make-file 30 'z)) empty))
(check-expect (convert 'y 'y fldH)
              (make-folder (list (make-file 10 'x) (make-file 30 'z)) empty))
(check-expect (convert 'y 'x fldH)
              (make-folder (list (make-file 10 'x) (make-file 30 'z)) empty))
(check-expect (convert 'x 'y fldH)
              (make-folder (list (make-file 10 'y) (make-file 30 'z)) empty))
(check-expect (convert 'x 'z fldH)
              (make-folder (list (make-file 10 'z) (make-file 30 'z)) empty))
(check-expect (convert 'z 'x fldH)
              (make-folder (list (make-file 10 'x) (make-file 30 'x)) empty))
              
(check-expect (convert 'x 'z fldI)
              (make-folder (list (make-file 10 'z) (make-file 25 'y)
                                 (make-file 30 'z) (make-file 50 'y)) empty))
(check-expect (convert 'x 'y fldI)
              (make-folder (list (make-file 10 'y) (make-file 25 'y)
                                 (make-file 30 'y) (make-file 50 'y)) empty))

(check-expect (convert 'z 'z fldI)fldI)
(check-expect (convert 'z 'y fldI)fldI)
              
              
(check-expect (convert 'y 'z fldJ)
             (make-folder
               (list (make-file 10 'x) (make-file 25 'z) (make-file 30 'z))
               (list
              (make-folder (list (make-file 10 'x) (make-file 25 'z) (make-file 30 'z)) empty)
              (make-folder (list (make-file 25 'x) (make-file 30 'x)) empty))))
(check-expect (convert 'y 'x fldJ)
              (make-folder
                (list (make-file 10 'x) (make-file 25 'x) (make-file 30 'z))
                (list
              (make-folder (list (make-file 10 'x) (make-file 25 'x) (make-file 30 'z)) empty)
              (make-folder (list (make-file 25 'x) (make-file 30 'x)) empty))))
(check-expect (convert 'x 'z fldJ)
              (make-folder
                (list (make-file 10 'z) (make-file 25 'y) (make-file 30 'z))
                (list
               (make-folder (list (make-file 10 'z) (make-file 25 'y) (make-file 30 'z)) empty)
               (make-folder (list (make-file 25 'z) (make-file 30 'z)) empty))))
(check-expect (convert 'z 'y fldM)
             (make-folder
               empty
               (list
             (make-folder (list (make-file 25 'x) (make-file 30 'x)) '())
             (make-folder
               (list (make-file 10 'y) (make-file 30 'x))
               (list (make-folder (list (make-file 10 'x) (make-file 25 'y)
                                        (make-file 30 'y)) empty))))))
(check-expect (convert 'z 'z fldM)
              (make-folder
               empty
               (list
               (make-folder (list (make-file 25 'x) (make-file 30 'x)) empty)
               (make-folder
                (list (make-file 10 'z) (make-file 30 'x))
                (list (make-folder (list (make-file 10 'x) (make-file 25 'y) (make-file 30 'z)) empty))))))
(check-expect (convert 'y 'y fldE)
              (make-folder
               empty
               (list
               (make-folder (list (make-file 25 'x) (make-file 30 'x)) empty)
               (make-folder (list (make-file 10 'z) (make-file 10 'y) (make-file 50 'y)) empty))))
(check-expect (convert 'x 'y fldC)
              (make-folder (list (make-file 10 'z) (make-file 10 'y)
                                 (make-file 50 'y)) empty))
(check-expect (convert 'x 'y fldF)
              (make-folder
                  (list (make-file 0 'y) (make-file 50 'z))
                  (list
                  (make-folder
                  (list (make-file 10 'z) (make-file 30 'y))
                  (list (make-folder (list (make-file 10 'y) (make-file 25 'y)
                                           (make-file 30 'z)) empty)))
              (make-folder
                  empty
                  (list
                  (make-folder (list (make-file 25 'y) (make-file 30 'y)) empty)
                  (make-folder (list (make-file 10 'z) (make-file 10 'y)
                                     (make-file 50 'y)) empty))))))
(check-expect (convert 'z 'x fldD)
              (make-folder
                  (list (make-file 10 'x) (make-file 30 'x))
                  (list (make-folder (list (make-file 10 'x) (make-file 25 'y)
                                           (make-file 30 'x)) empty))))
              
(check-expect(convert 'x 'y fldF)
             (make-folder
                 (list (make-file 0 'y) (make-file 50 'z))
                 (list
             (make-folder
                 (list (make-file 10 'z) (make-file 30 'y))
                 (list (make-folder (list (make-file 10 'y) (make-file 25 'y)
                                          (make-file 30 'z)) empty)))
             (make-folder
                empty
                (list
                (make-folder (list (make-file 25 'y) (make-file 30 'y)) empty)
                (make-folder (list (make-file 10 'z) (make-file 10 'y)
                                   (make-file 50 'y)) empty))))))
(check-expect(convert 'x 'z fldF)
             (make-folder
                (list (make-file 0 'z) (make-file 50 'z))
                (list
             (make-folder
                (list (make-file 10 'z) (make-file 30 'z))
                (list (make-folder (list (make-file 10 'z) (make-file 25 'y) (make-file 30 'z)) empty)))
             (make-folder
                empty
               (list
               (make-folder (list (make-file 25 'z) (make-file 30 'z)) empty)
               (make-folder (list (make-file 10 'z) (make-file 10 'y) (make-file 50 'y)) empty))))))
(check-expect(convert 'z 'y fldF)
             (make-folder
               (list (make-file 0 'x) (make-file 50 'y))
               (list
              (make-folder
               (list (make-file 10 'y) (make-file 30 'x))
               (list (make-folder (list (make-file 10 'x) (make-file 25 'y) (make-file 30 'y)) empty)))
              (make-folder
                empty
               (list
               (make-folder (list (make-file 25 'x) (make-file 30 'x)) empty)
               (make-folder (list (make-file 10 'y) (make-file 10 'y) (make-file 50 'y)) empty))))))
             




