;;; The function a-star uses the A* algorithm to find the
;;; shortest path from the start state to the goal state in a graph.
;;; It uses a hash table, STATE-DISTANCES, that keeps track of the length of
;;; the shortest path found so far from the start to each state visited
;;; during the search.
;;;
;;; The OPEN list is maintained as a list of NODE structures.
;;; Each NODE structure contains 3 fields, one for a path (represented as
;;; a list of states in reverse order), one for the length of this path,
;;; and one for the total path length estimate if this path is extended
;;; to the goal in the shortest possible way.
;;;
;;; We check states against the STATE-DISTANCES hash table in the same 2 places.
;;; In particular, we immediately discard any successor state if there is a path to it of
;;; equal or shorter length, and we also discard any path when it appears
;;; at the front of the OPEN list if there is a path of strictly shorter
;;; length ending at the same state.  If a state has no entry in this hash
;;; table, its distance from the start state is interpreted as being infinite.
;;;
;;; The application-specific functions that are to be passed to this program
;;; are: (1) SUCCESSORS, which returns a list of dotted pairs of the form
;;; ( <next state> . <cost of this arc> ), where <next state> is directly
;;; reachable from the given state in the problem graph; and
;;; (2) HEURISTIC-DIST, which takes 2 states and provides an estimate of the
;;; overall cost from the first to the second.  If this is an admissible
;;; (non-overestimating) heuristic, the A* algorithm is guaranteed to find
;;; the minimum-cost path; otherwise, there is no such guarantee.
;;;
;;; The return value from this function is a node structure.  When this prints
;;; out, the path and its length are shown.

(defstruct node
  path
  path-length
  total-length-estimate
  )


(defun a-star (start goal successors heuristic-dist)
  (do (head-node				; node at head of open list
       path-to-extend	        ; path to state currently visited
       current-state			; state currently visited
       dist-so-far				; length of this path
       extended-paths	        ; list of newly extended paths
       (open					; list of all candidate nodes
	(list (make-node :path (list start)
			 :path-length 0
			 :total-length-estimate
			 (funcall heuristic-dist start goal))))
       (state-distances (make-hash-table :test #'equalp))
       )
      ((null open) nil)	        	; if open list is empty, search fails
;      (format t                 	; lets us watch how algorithm works
;		"~%Open: ~s~%" open)
      (setq head-node (pop open))       			; get node at head of open list
      (setq path-to-extend (node-path head-node)) 	; get path itself
      (setq current-state (car path-to-extend)) 	; get state this path ends at
      (if (equalp current-state goal)
	  (return head-node))	; success: return path and length found
      (setq dist-so-far (node-path-length head-node))
      (when (less-than dist-so-far (gethash current-state state-distances))
	 (setf (gethash current-state state-distances) dist-so-far)
	 (let (next-state
	       next-dist-so-far
	       (next-nodes nil))
	   (dolist (pair (funcall successors current-state))
	     (setq next-state (car pair))
	     (setq next-dist-so-far (+ (cdr pair) dist-so-far))
	     (if (less-than next-dist-so-far
			    (gethash next-state state-distances))
		 (setf open
		       (merge
			'list
			(list
			 (make-node
			  :path (cons next-state path-to-extend)
			  :path-length next-dist-so-far
			  :total-length-estimate
			  (+ next-dist-so-far
			     (funcall heuristic-dist next-state goal))))
			open
			#'<
			:key #'node-total-length-estimate)))
		)))
      ))

;;; Here the y argument may be nil, which is treated like infinity.

(defun less-than (x y)
  (or (null y) (< x y)))


(defun successors (city)
  (case city
((1)	'((2	. 1.30722729)))										
((2)	'((3	. 2.138060668)	(1	. 1.30722729)))								
((3)	'((4	. 7.861610163)	(2	. 2.138060668)))								
((4)	'((5	. 0.78375784)	(3	. 7.861610163)))								
((5)	'((6	. 1.58571208)	(4	. 0.78375784)))								
((6)	'((5	. 1.58571208)	(8	. 5.708529668)))								
((7)	'((8	. 2.223779638)))										
((8)	'((14	. 3.851879599)	(7	. 2.223779638)	(6	. 5.708529668)))						
((9)	'((10	. 3.058546624)))										
((10)	'((17	. 4.074291199)	(14	. 4.077603047)	(9	. 3.058546624)))						
((11)	'((17	. 2.433820746)	(19	. 2.815945953)	(12	. 0.708366736)	(20	. 3.292492497)	(52	. 1.545939107)))		
((12)	'((43	. 1.955297559)	(13	. 2.23658635)	(11	. 0.708366736)))						
((13)	'((12	. 2.23658635)	(44	. 2.664629883)	(45	. 1.91088821)	(26	. 3.668132794)))				
((14)	'((8	. 3.851879599)	(16	. 1.844122441)	(10	. 4.077603047)))						
((15)	'((16	. 1.852068757)	(18	. 1.941368857)	(21	. 2.327257535)))						
((16)	'((15	. 1.852068757)))										
((17)	'((10	. 4.074291199)	(18	. 1.96458916)	(11	. 2.433820746)	(19	. 2.620042463)))				
((18)	'((15	. 1.941368857)	(17	. 1.96458916)))								
((19)	'((17	. 2.620042463)	(22	. 2.538743056)	(11	. 2.815945953)	(23	. 1.60177318)))				
((20)	'((11	. 3.292492497)	(23	. 1.353901548)	(25	. 1.645411944)	(45	. 3.045342553)))				
((21)	'((15	. 2.327257535)	(22	. 1.755128059)))								
((22)	'((21	. 1.755128059)	(19	. 2.538743056)	(24	. 2.111328189)	(29	. 2.337524628)	(28	. 1.480425311)))		
((23)	'((19	. 1.218560337)	(20	. 1.353901548)))								
((24)	'((22	. 2.111328189)	(25	. 0.963258424)))								
((25)	'((24	. 0.963258424)	(20	. 1.645411944)	(31	. 1.776652939)))						
((26)	'((31	. 0.869708108)	(13	. 3.668132794)))								
((27)	'((45	. 2.914541086)	(47	. 0.828358718)))								
((28)	'((22	. 1.480425311)	(42	. 0.632017715)))								
((29)	'((22	. 2.337524628)	(30	. 1.621434705)))								
((30)	'((29	. 1.621434705)	(33	. 0.539415677)	(34	. 1.468721178)	(31	. 0.488197688)))				
((31)	'((30	. 0.488197688)	(25	. 1.776652939)	(26	. 0.869708108)	(34	. 0.998916847)	(33	. 0.398398285)	))	
((32) 	'((34	. 0.270351585)))										
((33)	'((30	. 0.539415677)	(25	. 2.020730196)	(26	. 1.258767405)	(34	. 1.053296431)	(36	. 3.112392203)	(35	. 1.406005876)))
((34)	'((33	. 1.053296431)	(30	. 1.468721178)	(31	. 0.998916847)	(32	. 0.270351585)	(47	. 2.035208025)))		
((35)	'((46	. 0.802943193)	(33	. 1.406005876)))								
((36)	'((33	. 3.112392203)	(48	. 1.770906134)))								
((37)	'((49	. 1.515086568)	(38	. 3.025397737)	(40	. 4.67544816)))						
((38)	'((39	. 1.459960007)	(37	. 3.025397737)))								
((39)	'((38	. 1.459960007)	(51	. 2.828154127)))								
((40)	'((37	. 3.025397737)))										
((41)	'((48	. 2.151016125)	(50	. 1.14027569)))								
((42)	'((28	. 0.632017715)))										
((43)	'((12	. 1.955297559)))										
((44)	'((13	. 2.664629883)))										
((45)	'((13	. 1.91088821)	(20	. 3.045342553)	(27	. 2.914541086)))						
((46)	'((35	. 0.802943193)))										
((47)	'((27	. 0.828358718)	(34	. 2.035208025)	(49	. 1.997763534)))						
((48)	'((49	. 2.084395031)	(41	. 2.151016125)	(36	. 1.770906134)))						
((49)	'((47	. 1.997763534)	(48	. 2.084395031)	(37	. 1.515086568)))						
((50)	'((41	. 1.14027569)))										
((51)	'((39	. 2.828154127)))										
((52)	'((11	. 1.545939107)	(53	. 1.977900271)))								
((53)	'((52	. 1.977900271)	))									
	))


(defun get-dist(city1 city2)
	(setq lat1 (first (car (nthcdr (- city1 1) mapmex))))
    (setq lon1 (second (car (nthcdr (- city1 1) mapmex))))
    (setq lat2 (first (car (nthcdr (- city2 1) mapmex))))
    (setq lon2 (second (car (nthcdr (- city2 1) mapmex))))
    (sqrt (+ (expt (- lat2 lat1) 2) (expt (- lon2 lon1) 2)))
	)

(defun heuristic-dist (state goal)
  (get-dist state goal)
  )

(setq mapmex 
	'((22.894871 -109.917676)
	(24.141299 -110.311707)
	(26.011728 -111.347467)
	(31.856919 -116.604715)
	(32.511795 -117.035312)
	(32.62375 -115.453557)
	(31.301851 -110.936945)
	(29.0784761 -110.9793706)
	(31.6703988 -106.4412784)
	(28.634007 -106.073811)
	(25.428122 -100.9761904)
	(25.6488126 -100.3030789)
	(23.7358684 -99.1442161)
	(25.781529 -108.9876085)
	(23.2467867 -106.4221208)
	(24.8049172 -107.4233141)
	(25.5539641 -103.4067556)
	(24.0289606 -104.645293)
	(23.0831271 -102.5352127)
	(22.1356658 -100.9607303)
	(21.5006574 -104.883563)
	(20.673792 -103.3354131)
	(21.8890872 -102.2919885)
	(21.0251221 -101.2535212)
	(20.5910832 -100.3935927)
	(20.0893659 -98.7464502)
	(19.5354278 -96.9100715)
	(19.2465509 -103.7286585)
	(19.7039643 -101.2085714)
	(19.2944337 -99.6397071)
	(19.3200988 -99.1521845)
	(19.3067438 -98.2441899)
	(18.9316211 -99.2405376)
	(19.0412893 -98.192966)
	(17.54962 -99.4992372)
	(17.0966512 -96.7266023)
	(17.9925203 -92.9531082)
	(19.8305924 -90.5500846)
	(20.9627063 -89.6282379)
	(18.5213518 -88.3076639)
	(16.7460344 -93.132427)
	(19.0777207 -104.3377092)
	(27.451701 -99.5462553)
	(25.840444 -97.5098924)
	(22.2700063 -97.9183523)
	(16.8336281 -99.8626562)
	(19.1788058 -96.1624092)
	(16.1843 -95.2088)
	(18.1302882 -94.4619181)
	(16.23 -92.1156)
	(21.1823526 -86.808626)
	(26.9077923 -101.4239666)
	(28.6795295 -100.5447415)
		))

(defun write-file (name content)
    (with-open-file (stream name
        :direction :output
        :if-exists :overwrite
        :if-does-not-exist :create)
    (format stream content)))


(defun get-file (filename)
  (with-open-file (stream filename)
    (loop for line = (read-line stream nil)
          while line
          collect line)))

(setq linex (get-file "/Users/fernandasramirezm/Documents/Processing/interfazMapa/peticion.txt"))
(setq orig (parse-integer (car linex)) dest (parse-integer (cadr linex)))
;(+ orig 1)(+ dest 1)
;(close-input-file "peticion.txt")
(setq nodo (a-star (+ orig 1) (+ dest 1) #'successors #'heuristic-dist))
(write-file "/Users/fernandasramirezm/Documents/Processing/interfazMapa/respuesta.txt"(write-to-string nodo))