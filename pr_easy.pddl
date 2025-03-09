(define (problem basic-cleaning-problem)
  (:domain CleanerRobot)

  ;;------------------------------------------------------------
  ;; OBJECTS
  ;;------------------------------------------------------------
  (:objects
    r1 - robot
    room1 room2 room3 room4 room5 - room
  )

  ;;------------------------------------------------------------
  ;; INITIAL STATE
  ;;------------------------------------------------------------
  (:init
    ;; Robot's initial position
    (at r1 room1)
    
    ;; Connections (assume bidirectional for free movement)
    (connected room1 room2)
    (connected room2 room1)
    (connected room2 room3)
    (connected room3 room2)
    (connected room2 room4)
    (connected room4 room2)
    (connected room3 room5)
    (connected room5 room3)

    ;; Trash bins in rooms 3 and 4
    (trash-bin room4) 

    ;; One dirty room
    (dirty room5)

    ;; Rooms with trash
    (trash-in room2)

    (charging-station room3)  ;; Room 2 has a charger
    (charged-5 r1)  ;; Start with 5 charge
  )

  ;;------------------------------------------------------------
  ;; GOAL
  ;;------------------------------------------------------------
  ;; Goal: Room 4 is not dirty, no trash remains on floors,
  ;; and the robot isn’t holding any trash.
  (:goal (and
    (not (dirty room5))
    (not (trash-in room2))
    (not (trash-in room5))
    (not (has-trash r1))
  ))
)