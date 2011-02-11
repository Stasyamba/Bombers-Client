package components.common.game.requesttogame
{
	import engine.games.GameType;

	public interface  IRequestContent
	{
		function initContent(rgo: RequestGameObject): void;
		function getGameType(): GameType;
		
	}
}