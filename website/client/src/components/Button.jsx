import React from 'react'

const Button = ({ 
  children, 
  onClick, 
  variant = 'secondary', 
  size = 'normal',
  disabled = false,
  className = '',
  ...props 
}) => {
  const baseClasses = 'font-semibold rounded-ios transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed touch-target no-select'
  
  const variantClasses = {
    primary: 'bg-primary text-white shadow-ios dark:shadow-ios-dark hover:bg-blue-600 active:bg-blue-700',
    secondary: 'bg-card dark:bg-card-dark text-primary border border-primary shadow-ios dark:shadow-ios-dark hover:bg-gray-50 dark:hover:bg-gray-700 active:bg-gray-100 dark:active:bg-gray-600',
    destructive: 'bg-destructive text-white shadow-ios dark:shadow-ios-dark hover:bg-red-600 active:bg-red-700',
    success: 'bg-success text-white shadow-ios dark:shadow-ios-dark hover:bg-green-600 active:bg-green-700'
  }
  
  const sizeClasses = {
    small: 'px-3 py-2 text-sm sm:px-4',
    normal: 'px-4 py-3 text-base sm:px-6',
    large: 'px-6 py-4 text-base sm:text-lg w-full sm:px-8'
  }

  const classes = [
    baseClasses,
    variantClasses[variant],
    sizeClasses[size],
    className
  ].join(' ')

  return (
    <button
      className={classes}
      onClick={onClick}
      disabled={disabled}
      {...props}
    >
      {children}
    </button>
  )
}

export default Button