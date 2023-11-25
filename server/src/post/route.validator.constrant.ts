import {
  ValidatorConstraint,
  ValidatorConstraintInterface,
} from 'class-validator';

const between = <T>(value: T, min: T, max: T) => {
  return min <= value && value <= max;
};

@ValidatorConstraint({ name: 'IsCoordinate', async: false })
export class IsCoordinate implements ValidatorConstraintInterface {
  errors: string[];

  validate(value: any): boolean | Promise<boolean> {
    this.errors ??= [];
    if (!Array.isArray(value) || value.length !== 2) {
      this.errors.push(`coordinates ${value} should be a pair [x, y]`);
    }
    const [longitude, latitude] = value;

    if (typeof longitude !== 'number' || typeof latitude !== 'number') {
      this.errors.push(
        `longitude ${longitude} and latitude ${latitude} shoud be a number`,
      );
    }
    if (!between(longitude, -180, 180) || !between(latitude, -90, 90)) {
      this.errors.push(
        `-180 < longitude(${longitude}) < 180 && -90 < latitude(${latitude}) < 90`,
      );
    }

    return this.errors.length === 0;
  }

  defaultMessage(): string {
    return this.errors.join(', ');
  }
}
