Testing and Analysis

Show the results of usability testing (if any) and the learning results. Compare with the different types and no learning, show graphs to compare. Discuss the effectiveness, advantages/disadvantages to the learning algorithms used.

Results
Analysis of Decision Tree Learning
Possible Improvements
Analysis of Reinforcement Learning
Possible Improvements

Evaluation

A very competent evaluation of the whole project (with hindsight). Weak performance in the evaluation of product and process will result in a grade no higher than a B.

Time Management
Initial plan was to use a waterfall development approach (discuss). Eventually took a slightly more incremental approach: developed game and AI together towards the end, some asset creation throughout. Discuss why, which would have been better - for one person rather than a team. As I was unfamiliar with the language and the engine, it was difficult to decide how best to approach the design/implementation. (see \url{http://en.wikipedia.org/wiki/Software_development_methodology})
		
- Waterfall: a linear framework
- Incremental: a combined linear-iterative framework
- Spiral: a combined linear-iterative framework
		
	Achievements

Evaluation of reinforcement learning

+ it can handle uncertain and noisy domains
+ it can interface with an external world more easily than other methods
- slow learning rate as they rely on backwards propagation of rewards. The problem solver must pass through early parts of the problem space many times before any rewards at all reach those locales.


	Areas For Enhancement
- Implement additional learning types
- Mixed learning types between agents
- Use a combination of types
- Communication between agents (shared knowledge base?)
- Extend to a 3D environment
- Level editor
- "Start with a large correction factor (learning rate), and slowly decrease the parameter, which gives the algorithm a rough approximation during the early stages and allows fine tuning later in learning."
- Test alternative reinforcement methods (bucket brigade, temporal difference)
- Negatives of using reinforcement learning: it doesn't generalise beyond specific states. Possible fix: use genetic algorithms - "the expected reward on production rules serves as their fitness, with more fit rules being selected for reproduction. The new rules are then evaluated by running them in an environment, with the best of them being selected to produce another generation, and so on. Such classifier systems are often used in conjunction with the bucket brigade algorithm for determining expected rewards." 

Overall Success
- Applications For Learning in games (possibly pre-release learning)
- Performance on mobile device