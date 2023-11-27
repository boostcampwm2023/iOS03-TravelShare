import data from './nicknamedata.json';
const prenounArray: string[] = data.prenoun;
const animalArray: string[] = data.animal;

export function getRandomNickName() {
  const prenounIdx: number =
    Math.floor(Math.random() * prenounArray.length * 7) % prenounArray.length;
  const animalIdx: number =
    Math.floor(Math.random() * animalArray.length * 7) % animalArray.length;
  const nickname: string = `${prenounArray[prenounIdx]} ${animalArray[animalIdx]}`;
  return nickname;
}
