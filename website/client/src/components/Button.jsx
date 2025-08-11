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
  const baseClasses = 'font-semibold rounded-ios transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed'
  
  const variantClasses = {
    primary: 'bg-primary text-white shadow-ios hover:bg-blue-600 active:bg-blue-700',
    secondary: 'bg-card text-primary border border-primary shadow-ios hover:bg-gray-50 active:bg-gray-100',
    destructive: 'bg-destructive text-white shadow-ios hover:bg-red-600 active:bg-red-700',
    success: 'bg-success text-white shadow-ios hover:bg-green-600 active:bg-green-700'
  }
  
  const sizeClasses = {
    small: 'px-4 py-2 text-sm',
    normal: 'px-6 py-3 text-base',
    large: 'px-8 py-4 text-lg w-full'
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