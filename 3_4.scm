(define (make-account balance password)
    (define (make-account-w balance password wrong-cnt)
        (define (withdraw amount)
            (if (>= balance amount)
                (begin (set! balance (- balance amount)) balance)
                "Insufficient funds"))
        (define (deposit amount)
            (set! balance (+ balance amount))
            balance)
        (define (dispatch m)
            (cond 
                ((eq? m 'withdraw) withdraw)
                ((eq? m 'deposit) deposit)
                (else (error "Unknown request -- MAKE_ACCOUNT" m))))
        (define (call-the-cops)
            (error "call the cops"))
        (define (dispatch_pwd in_pwd m)
            (if (eq? in_pwd password)
                (dispatch m)
                (begin (set! wrong-cnt (+ 1 wrong-cnt)) 
                    (if (>= wrong-cnt 7)
                        (call-the-cops)
                        (error "Incorrect password")))))
        dispatch_pwd
    )
    (make-account-w balance password 0)
)

(define acc (make-account 100 'secret-password))
((acc 'secret-password 'withdraw) 40)

((acc 'wrong-pwd 'deposit) 10)
((acc 'wrong-pwd 'deposit) 10)
((acc 'wrong-pwd 'deposit) 10)
((acc 'wrong-pwd 'deposit) 10)
((acc 'wrong-pwd 'deposit) 10)
((acc 'wrong-pwd 'deposit) 10)
((acc 'wrong-pwd 'deposit) 10)

((acc 'secret-password 'deposit) 10)