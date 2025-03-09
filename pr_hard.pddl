(define (problem basic-cleaning-problem)
  (:domain CleanerRobot)

  ;;------------------------------------------------------------
  ;; OBJECTS
  ;;------------------------------------------------------------
  (:objects
    r1 - robot
    room1 room2 room3 room4 room5 room6 room7 - room
    k1 k2 - key
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
    (connected room2 room5)
    (connected room5 room2)
    (connected room4 room5)
    (connected room5 room4)
    (connected room5 room6)
    (connected room6 room5)
    (connected room5 room7)
    (connected room7 room5)
    
    ;; Locked doors
    (locked room4 room5)
    (locked room5 room4)
    (locked room5 room7)
    (locked room7 room5)
    
    ;; Two keys
    (key-in k1 room6)
    (opens k1 room5 room7)
    (opens k1 room7 room5)
    
    (key-in k2 room7)
    (opens k2 room4 room5)
    (opens k2 room5 room4)

    ;; Trash bins in rooms 3 and 4
    (trash-bin room7)
    (trash-bin room4)

    ;; One dirty room
    (dirty room4)
    (dirty room3)

    ;; Rooms with trash
    (trash-in room5)
    (trash-in room6)
    
    (charging-station room2)  ;; Room 2 has a charger
    (charged-5 r1)  ;; Start with 5 charge
  )

  ;;------------------------------------------------------------
  ;; GOAL
  ;;------------------------------------------------------------
  ;; Goal: Room 4 is not dirty, no trash remains on floors,
  ;; and the robot isn’t holding any trash.
  (:goal (and
    (not (dirty room3))
    (not (dirty room4))
    (not (trash-in room5))
    (not (trash-in room6))
    (not (has-trash r1))
  ))
)
