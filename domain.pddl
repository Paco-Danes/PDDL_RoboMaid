(define (domain CleanerRobot)
    (:requirements :strips :typing :negative-preconditions)

    ;;------------------------------------------------------------
    ;; TYPES
    ;;------------------------------------------------------------
    (:types
        robot room key
    )

    ;;------------------------------------------------------------
    ;; PREDICATES
    ;;------------------------------------------------------------
    (:predicates
        ;; Robot ?r is currently in room ?rm
        (at ?r - robot ?rm - room)

        ;; Room ?rm is dirty and needs cleaning
        (dirty ?rm - room)

        ;; There is trash on the floor in room ?rm
        (trash-in ?rm - room)

        ;; The robot ?r is currently holding trash
        (has-trash ?r - robot)

        ;; Room ?rm has a trash bin
        (trash-bin ?rm - room)

        ;; Rooms ?rm1 and ?rm2 are connected (for free movement)
        (connected ?rm1 - room ?rm2 - room)

        ;; Is there a locked door between these two rooms?
        (locked ?rm1 - room ?rm2 - room)

        ;; Robot ?r currently holds key ?k
        (has-key ?r - robot ?k - key)

        ;; Key ?k is in room ?rm
        (key-in ?k - key ?rm - room)

        ;; Key ?k opens the door between ?rm1 and ?rm2
        (opens ?k - key ?rm1 - room ?rm2 - room)
    )

    ;;------------------------------------------------------------
    ;; ACTIONS
    ;;------------------------------------------------------------

    ;; 1) Move the robot from one room to a connected room.
    (:action move
        :parameters (?r - robot ?from - room ?to - room)
        :precondition (and
            (at ?r ?from)
            (connected ?from ?to)
            (not (locked ?from ?to))
        )
        :effect (and
            (not (at ?r ?from))
            (at ?r ?to)
        )
    )

    ;; 2) Clean a room if it is dirty (removes "dirty" status).
    (:action clean-room
        :parameters (?r - robot ?rm - room)
        :precondition (and
            (at ?r ?rm)
            (dirty ?rm)
        )
        :effect (and
            (not (dirty ?rm))
        )
    )

    ;; 3) Pick up trash from the room
    (:action pick-up-trash
        :parameters (?r - robot ?rm - room)
        :precondition (and
            (at ?r ?rm)
            (trash-in ?rm)
            (not (has-trash ?r))
        )
        :effect (and
            (not (trash-in ?rm))
            (has-trash ?r)
        )
    )

    ;; 4) Dispose of trash if the robot is holding it and is in a room with a trash bin.
    (:action dispose-trash
        :parameters (?r - robot ?rm - room)
        :precondition (and
            (at ?r ?rm)
            (has-trash ?r)
            (trash-bin ?rm)
        )
        :effect (and
            (not (has-trash ?r))
        )
    )

    ;; 5) Pick up a specific key if it is in the room
    (:action pick-up-key
        :parameters (?r - robot ?k - key ?rm - room)
        :precondition (and
            (at ?r ?rm)
            (key-in ?k ?rm)
            (not (has-key ?r ?k)))
        :effect (and
            (not (key-in ?k ?rm))
            (has-key ?r ?k)
        )
    )

    ;; 6) Unlock a locked door between two rooms using the correct key
    (:action unlock-door
        :parameters (?r - robot ?k - key ?rm1 - room ?rm2 - room)
        :precondition (and
            (at ?r ?rm1)
            (locked ?rm1 ?rm2)
            (has-key ?r ?k) ;; Robot must have the key
            (opens ?k ?rm1 ?rm2) ;; Key must match the locked door
        )
        :effect (and
            (not (locked ?rm1 ?rm2))
            (not (locked ?rm2 ?rm1)) ;; Unlock bidirectionally
        )
    )
)