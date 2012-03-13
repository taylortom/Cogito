Artificial Intelligence [Background Research]

- Intro to AI, differences between academic AI and game AI

"Learning is the improvement in performance in some environment through the acquisition of knowledge resulting from experience in that environment." - Elements of Machine Learning - Pat Langley

"Learning involves improvement in performance." - Elements of Machine Learning - Pat Langley

"The ability to learn is one of the central features of intelligence" - Elements of Machine Learning - Pat Langley

(how research has influenced your decisions - there must be evidence of appropriate research)

The motivation for my project came from the fact that most modern games still use very rudimentary techniques when it comes to the artificial intelligence.

Although the reasons for this are very understandable, we reached the so-called pinnacle of graphics development 

AI In Games
- Smoke and mirrors
- scripting: why use it
	- speed
	- predictability (testing) 
- examples of machine learning in commercial games (Black & White)

Machine Learning
- What is it
- types of learning: supervised/unsupervised, online/offline
"in some cases a tutor or domain expert gives the learner direct feedback about the appropriateness of its performance."
"For classification problems, the supervised task assumes that each training instance includes an attribute that specifies the class of that instance, and the goal is to induce a concept description that accurately predicts this attribute. There is less agreement on the goal of unsupervised learning, but one can define analogous prediction tasks over the entire set of attributes. In problem solving tasks, supervised learning occurs when a tutor suggests the correct step at each point in the search or reasoning process; systems that operate on such feedback are sometimes referred to as learning apprentices. However, most work on learning in problem solving has dealt with unsupervised tasks, in which the agent must distinguish desirable actions from undesirable ones on its own." - Elements of Machine Learning - Pat Langley
- what is it used for 

Types of learning:

Reinforcement: 
"One approach to the acquisition of problem-solving knowledge, reinforcement learning, focuses on preference knowledge for the selection of operators. Because this class of methods does not require information about operator effects, it is commonly applied to learning from sequences of external actions. However, many of the same issues arise in this context as with internal problem solving, and we will not typically distinguish between them.
In addition to a set of (possibly opaque) operators, a reinforcement learning system is provided with some reward function that evaluates states. Intuitively, states with higher rewards are more desirable than ones with low or negative rewards, and the agent aims to approach the former and avoid the latter. Learning involves the acquisition of a control strategy that leads to states with high rewards, based on experience with the rewards produced by observed operator sequences.

The Simplest approach to reinforcement learning stores knowledge in a table. Each entry describes a possible state-action pair, along with the expected reward that results from applying the action to that state."

"Typically, the problem solver uses this table to direct forward-chaining search. This involves finding the table entry for the current state, selecting the action that gives the highest expected score, and applying this action to produce a new state. The problem solver continues this cycle, producing a forward-chaining greedy search through the state space, until it reaches the desired state or some other halting condition."

"Reinforcement learning alters the predicted rewards stored int the state-action table on the basis of experience. The entries typically start with either random values, or equal ones, but the score for a given state-action pair <s,a> changes whenever the problem solver applies action a in state s. This produces a new state and a resulting reward, which the learner uses to revise the existing entry."

"This strategy, known as Q-learning, computes the sum of the immediate reward and the discounted maximum reward expected for the following state, then subtracts the current entry for the state-action pair. It then multiplies the difference by the correction rate and modifies the entry in question by the resulting product. The discount factor specifies the the importance of immediate versus delayed gratification, whereas the correction factor determines the rate at which the learner revises table entries."

"Given enough training cases, this learning scheme converges on the expression Q(s,a) = r(s,a) + discount factor(U(s prime)) as the entry for each state-action pair <s,a> in the table."

"Thus, after sufficient experience, the problem solver can move toward the most desirable state from any location with little to no search"

Academic Research

Machine Learning/Applications

Why Use Machine Learning In Games

I feel that the possibility of utilising academic machine learning techniques into commercial computer games is an often overlooked technique which is not only possible, but feasible with todays technology; something I have proven by showing this on a mobile platform. 

Machine learning in games could have many possible applications. The obvious use is to create much 'smarter' AI-controlled characters which are capable of modifying their behaviour dynamically to adapt to unforeseen scenarios. This could be applied to virtually any game genre, from enemy commanders in a real-time strategy war game, to the AI-controlled players in a football game, to more intelligent enemy characters in a platform game. Some applications are often more pertinent than others; performance is still of paramount importance, and is still an issues; mostly so with console games where the hardware capabilities is strictly limited, and even more so on mobile devices.