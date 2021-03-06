(define (make-table same-key?)
    (let ((local-table (list '*table*)))

        (define (assoc key records)
            (cond ((null? records) false)
                ((same-key? key (caar records)) (car records))
                (else (assoc key (cdr records)))))

        (define (lookup keys)
            (lookup keys local-table))
        (define (lookup keys table)
            (let ((subtable (assoc (car keys) (cdr table))))
                (cond 
                    ((subtable)
                        (if (null? (cdr keys))
                            (cdr subtable)
                            (else (lookup (cdr keys) subtable))))
                    (else false))))

        (define (insert! keys value)
            (insert! keys value local-table))
        (define (insert! keys value table)
            (define (construct-key-chain keys value)
                (if (null? (cdr keys))
                    (cons (cons (car keys) value) '())
                    (cons (car keys) (construct-key-chain (cdr keys) value))))
            (let ((subtable (assoc (car keys) (cdr table))))
                (if (subtable)
                    (if (null? (cdr keys))
                        (set-cdr! subtable value)
                        (insert! (cdr keys) subtable))
                    (set-cdr! table
                        (cons (construct-key-chain keys value) (cdr table)))))
            'ok)
        (define (dispatch m)
            (cond 
                ((eq? m 'lookup-proc) lookup)
                ((eq? m 'insert-proc!) insert!)
                (else (error "Unknown operation -- TABLE" m))))
        dispatch))

(define operation-table (make-table))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc))