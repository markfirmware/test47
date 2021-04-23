| repoDir |
repoDir := (Smalltalk os environment at: #PWD) asFileReference parent.
(IceRepository registry
    anySatisfy: [ :repo | repo location = repoDir ])
        ifFalse: [
            | repo |
            repo := IceRepositoryCreator new
                location: repoDir;
                createRepository.
            repo register.
            repo workingCopy packages isEmpty
                ifFalse: [
                    repo workingCopy packages do: [ :p | p load ]
                ] ifTrue: [
                    | className baselineClassName |
                    className := repoDir basename capitalized.
                    Object subclass: className
                    	instanceVariableNames: ''
	                classVariableNames: ''
	                package: className.
                    repo workingCopy addPackageNamed: className.
                    baselineClassName := ('BaselineOf' , className).
                    BaselineOf subclass: baselineClassName
                    	instanceVariableNames: ''
	                classVariableNames: ''
	                package: baselineClassName.
                    repo workingCopy addPackageNamed: baselineClassName
                ]
        ]
